module AHB_to_APB_tb;
reg hclk, hresetn;
wire penable_out, pwrite_out;
wire [31:0] paddr_out, pwdata_out, prdata;
wire [2:0] pselx_out;
wire [31:0] hrdata;
wire [31:0] haddr, hwdata;
wire hwrite, hreadyin, hreadyout;
wire [1:0] htrans;
wire [2:0] pselx;
wire penable, pwrite;
wire [31:0] paddr, pwdata;
wire [1:0] hresp;
AHB_master AHB_m1(hclk,hresetn,hreadyout,hrdata,hwrite,hreadyin,htrans,haddr,hwdata);
bridge_top bt1(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,prdata,pwrite,penable,pselx,paddr,pwdata,hreadyout,hresp,hrdata);
APB_interface APB_i1(penable,pwrite,pselx,paddr,pwdata,penable_out,pwrite_out,pselx_out,paddr_out,pwdata_out,prdata);
initial hclk = 1'b0;
always #10 hclk = ~hclk;
task reset;
begin
  @(negedge hclk) hresetn = 1'b0;
  @(negedge hclk) hresetn = 1'b1;
end
endtask
initial begin
  reset;
  AHB_m1.burst_read_wrap4;
end
initial #1000 $finish;
endmodule
