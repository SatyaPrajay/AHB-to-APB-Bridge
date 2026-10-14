module AHB_slave_interface(hclk,hresetn,hwrite,hreadyin,htrans,hresp,hrdata,haddr,hwdata,
                           valid,hwrite_reg,tempselx,haddr1,haddr2,hwdata1,hwdata2,prdata);
  input hclk, hresetn, hwrite, hreadyin;
  input [1:0] htrans;
  input [31:0] haddr, hwdata, prdata;
  output reg valid, hwrite_reg;
  output wire [1:0] hresp;
  output wire [31:0] hrdata;
  output reg [2:0] tempselx;
  output reg [31:0] haddr1, haddr2, hwdata1, hwdata2;

  always @(posedge hclk) begin
    if (!hresetn) begin haddr1 <= 0; haddr2 <= 0; end
    else begin haddr1 <= haddr; haddr2 <= haddr1; end
  end
  always @(posedge hclk) begin
    if (!hresetn) begin hwdata1 <= 0; hwdata2 <= 0; end
    else begin hwdata1 <= hwdata; hwdata2 <= hwdata1; end
  end
  always @(posedge hclk) begin
    if (!hresetn) hwrite_reg <= 0;
    else hwrite_reg <= hwrite;
  end
  always @(*) begin
    valid = 0;
    if (hreadyin && (htrans == 2'b10 || htrans == 2'b11) &&
        (haddr >= 32'h8000_0000 && haddr < 32'h8c00_0000)) valid = 1;
  end
  always @(*) begin
    tempselx = 3'b000;
    if (haddr >= 32'h8000_0000 && haddr < 32'h8400_0000) tempselx = 3'b001;
    else if (haddr >= 32'h8400_0000 && haddr < 32'h8800_0000) tempselx = 3'b010;
    else if (haddr >= 32'h8800_0000 && haddr < 32'h8c00_0000) tempselx = 3'b100;
  end
  assign hresp = 0;
  assign hrdata = prdata;
endmodule
