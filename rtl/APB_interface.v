module APB_interface(
  input penable, pwrite,
  input [2:0] pselx,
  input [31:0] paddr, pwdata,
  output penable_out, pwrite_out,
  output [2:0] pselx_out,
  output [31:0] paddr_out, pwdata_out,
  output reg [31:0] prdata);
  assign penable_out = penable;
  assign pwrite_out = pwrite;
  assign paddr_out = paddr;
  assign pselx_out = pselx;
  assign pwdata_out = pwdata;
  always @(*) begin
    if(~pwrite && penable) prdata = {$random};
    else prdata = 32'h0;
  end
endmodule
