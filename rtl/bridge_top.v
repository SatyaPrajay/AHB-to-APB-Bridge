module bridge_top(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,
                  prdata,pwrite,penable,pselx,paddr,pwdata,hreadyout,hresp,hrdata);
input hclk, hresetn, hwrite, hreadyin;
input [1:0] htrans;
input [31:0] haddr, hwdata, prdata;
output pwrite, penable, hreadyout;
output [1:0] hresp;
output [2:0] pselx;
output [31:0] paddr, pwdata, hrdata;
wire valid, hwrite_reg;
wire [31:0] haddr1, haddr2, hwdata1, hwdata2;
wire [2:0] tempselx;
AHB_slave_interface ASI(hclk,hresetn,hwrite,hreadyin,htrans,hresp,hrdata,haddr,hwdata,
                        valid,hwrite_reg,tempselx,haddr1,haddr2,hwdata1,hwdata2,prdata);
APB_controller AC(hclk,hresetn,hwrite,hwrite_reg,valid,haddr,haddr1,haddr2,hwdata,hwdata1,hwdata2,
                  prdata,tempselx,pwrite,penable,pselx,paddr,pwdata,hreadyout);
endmodule
