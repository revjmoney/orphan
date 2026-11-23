"""Native job preparation with a portable Python fallback; CPU oracle stays separate."""
import ctypes,struct
from pathlib import Path
from reference import generate_matrix as python_matrix
try:
    native=ctypes.CDLL(str(Path(__file__).with_name('matrix_native.so')))
    native.kaspa_matrix.argtypes=[ctypes.POINTER(ctypes.c_uint8),ctypes.POINTER(ctypes.c_uint32)]
    native.kaspa_matrix.restype=ctypes.c_int
except OSError:native=None
class PackedMatrix:
    def __init__(self,words):self.packed_words=words;self.rows=None
    def __len__(self):return 64
    def __iter__(self):
        if self.rows is None:
            self.rows=[[n for word in self.packed_words[r*8:r*8+8] for n in ((word>>(4*i))&15 for i in range(8))] for r in range(64)]
        return iter(self.rows)
    def __eq__(self,other):return self.packed_words==other.packed_words if isinstance(other,PackedMatrix) else list(self)==other
def generate_matrix(seed):
    if native is None:return python_matrix(seed)
    if len(seed)!=32:raise ValueError('Pre-PoW hash must contain 32 bytes')
    source=(ctypes.c_uint8*32).from_buffer_copy(seed);words=(ctypes.c_uint32*512)()
    if native.kaspa_matrix(source,words)<1:raise ValueError('Invalid seed or matrix generation did not converge')
    return PackedMatrix(struct.unpack('<512I',bytes(words)))
