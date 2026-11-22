from pathlib import Path
import json
LEVEL=['1111111111111111','1000000000000001','1011100000111001','1000100000100001',
       '1000100000100001','1000000000000001','1000001111000001','1000001001000001',
       '1000001001000001','1000000000000001','1011100000111001','1000000000000001',
       '1000000000000001','1000000000000001','1000000000000001','1111111111111111']
text=['module toy_map(input wire [3:0] y,output reg [15:0] row);','always @* case(y)']
text += [f"4'd{i}:row=16'h{int(row[::-1],2):04x};" for i,row in enumerate(LEVEL)]
text+=['endcase','endmodule','module toy_projection(input wire [7:0] distance,output reg [7:0] height);','always @* case(distance)']
text += [f"8'd{i}:height=8'd{min(120,1920//max(1,i))};" for i in range(256)]
text+=['endcase','endmodule']
Path(__file__).with_name('orphan_toys').joinpath('toy_rom.v').write_text('\n'.join(text)+'\n')
Path(__file__).with_name('orphan_toys').joinpath('level.json').write_text(json.dumps(LEVEL))
