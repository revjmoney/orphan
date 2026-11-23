"""CPU kHeavyHash oracle, using Kaspa serialized little-endian byte order.

Reference: kaspanet/rusty-kaspa consensus/pow and crypto/hashes.
Generic cSHAKE domain encoding is independent of the FPGA initial states.
"""
import struct
MASK = (1 << 64) - 1
RC = (0x1, 0x8082, 0x800000000000808A, 0x8000000080008000,
      0x808B, 0x80000001, 0x8000000080008081, 0x8000000000008009,
      0x8A, 0x88, 0x80008009, 0x8000000A, 0x8000808B,
      0x800000000000008B, 0x8000000000008089, 0x8000000000008003,
      0x8000000000008002, 0x8000000000000080, 0x800A,
      0x800000008000000A, 0x8000000080008081, 0x8000000000008080,
      0x80000001, 0x8000000080008008)
RHO = ((0, 36, 3, 41, 18), (1, 44, 10, 45, 2),
       (62, 6, 43, 15, 61), (28, 55, 25, 21, 56), (27, 20, 39, 8, 14))

def rol(v, n):
    return ((v << n) | (v >> (64 - n))) & MASK

def keccak(a):
    a = list(a)
    for rc in RC:
        c = [a[x] ^ a[x+5] ^ a[x+10] ^ a[x+15] ^ a[x+20] for x in range(5)]
        d = [c[(x-1) % 5] ^ rol(c[(x+1) % 5], 1) for x in range(5)]
        b = [0] * 25
        for x in range(5):
            for y in range(5):
                b[y + 5*((2*x+3*y) % 5)] = rol(a[x+5*y] ^ d[x], RHO[x][y])
        a = [b[x+5*y] ^ ((~b[(x+1) % 5+5*y]) & b[(x+2) % 5+5*y])
             for y in range(5) for x in range(5)]
        a[0] ^= rc
    return a

def left_encode(n):
    size = max(1, (n.bit_length()+7)//8)
    return bytes([size]) + n.to_bytes(size, 'big')

def cshake(data, custom):
    prefix = left_encode(136) + left_encode(0) + left_encode(8*len(custom)) + custom
    prefix += bytes((-len(prefix)) % 136)
    msg = bytearray(prefix + data + b'\x04')
    msg += bytes((-len(msg)) % 136)
    msg[-1] |= 128
    state = [0]*25
    for pos in range(0, len(msg), 136):
        for i, w in enumerate(struct.unpack('<17Q', msg[pos:pos+136])):
            state[i] ^= w
        state = keccak(state)
    return struct.pack('<4Q', *state[:4])

def xoshiro(seed):
    s = list(struct.unpack('<4Q', seed))
    while True:
        result = (s[0] + rol((s[0]+s[3]) & MASK, 23)) & MASK
        t = (s[1] << 17) & MASK
        s[2] ^= s[0]; s[3] ^= s[1]; s[1] ^= s[2]; s[0] ^= s[3]
        s[2] ^= t; s[3] = rol(s[3], 45)
        yield result

def rank(matrix):
    a = [list(map(float, row)) for row in matrix]
    selected = [False]*64
    rank_value = 0
    for i in range(64):
        j = next((j for j in range(64) if not selected[j] and abs(a[j][i]) > 1e-9), None)
        if j is None:
            continue
        selected[j] = True
        rank_value += 1
        for p in range(i+1, 64):
            a[j][p] /= a[j][i]
        for k in range(64):
            if k != j and abs(a[k][i]) > 1e-9:
                v = a[k][i]
                for p in range(i+1, 64):
                    a[k][p] -= a[j][p]*v
    return rank_value

def generate_matrix(seed):
    if len(seed) != 32 or seed == bytes(32):
        raise ValueError('pre-PoW hash must be 32 bytes and nonzero')
    rng = xoshiro(seed)
    for _ in range(1024):
        m = []
        for row in range(64):
            values = [next(rng) for _ in range(4)]
            m.append([(values[c//16] >> (4*(c % 16))) & 15 for c in range(64)])
        if rank(m) == 64:
            return m
    raise ValueError('matrix generation did not converge')

def heavy_hash(first, matrix):
    vec = [n for b in first for n in (b >> 4, b & 15)]
    sums = [sum(a*b for a, b in zip(row, vec)) >> 10 for row in matrix]
    mixed = bytes((((sums[2*i] << 4) | sums[2*i+1]) ^ first[i]) for i in range(32))
    return cshake(mixed, b'HeavyHash')

def pow_hash(seed, timestamp, nonce):
    return cshake(seed + struct.pack('<Q', timestamp) + bytes(32) + struct.pack('<Q', nonce), b'ProofOfWorkHash')

def kheavyhash(seed, timestamp, nonce, matrix=None):
    return heavy_hash(pow_hash(seed, timestamp, nonce), matrix if matrix is not None else generate_matrix(seed))

def matrix_words(matrix):
    if hasattr(matrix,'packed_words'):return list(matrix.packed_words)
    return [sum(row[c+n] << (4*n) for n in range(8)) for row in matrix for c in range(0, 64, 8)]
