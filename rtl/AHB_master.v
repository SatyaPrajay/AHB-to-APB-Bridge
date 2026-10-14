module AHB_master(
  input hclk, hresetn, hreadyout,
  input [31:0] hrdata,
  output reg hwrite, hreadyin,
  output reg [1:0] htrans,
  output reg [31:0] haddr, hwdata);

  reg [2:0] hburst;
  reg [2:0] hsize;
  integer i;

  task single_write();
  begin
    @(posedge hclk) #1;
    hwrite = 1; htrans = 2'd2; hsize = 0; hburst = 0;
    hreadyin = 1; haddr = 32'h8000_0000;
    @(posedge hclk) #1;
    hwrite = 0; haddr = 32'h0000_0000; hwdata = 32'h22; htrans = 2'd0;
  end
  endtask

  task single_read();
  begin
    @(posedge hclk) #1;
    hwrite = 0; htrans = 2'd2; hsize = 0; hburst = 0;
    hreadyin = 1; haddr = 32'h8000_0000;
    @(posedge hclk) #1;
    hwrite = 0; haddr = 32'h0000_0000; hreadyin = 0; htrans = 2'd0;
  end
  endtask

  task burst_4_incr_write();
  begin
    @(posedge hclk); #1;
    hwrite = 1; htrans = 2'd2; hsize = 3'd0; hburst = 3'd3;
    hreadyin = 1; haddr = 32'h8000_0000;
    for(i = 0; i < 3; i = i + 1) begin
      @(posedge hclk); #1;
      haddr = haddr + 1; htrans = 2'd3; hwdata = {$random} % 256;
    end
    @(posedge hclk); #1;
    htrans = 2'd0; hwrite = 0; hwdata = {$random} % 256; haddr = 32'h0000_0000;
  end
  endtask

  task burst_write_wrap4();
  begin
    @(posedge hclk) #1;
    hwrite = 1; hsize = 0; hburst = 3'd2; htrans = 2'd2;
    hreadyin = 1; haddr = 32'h8000_0038;
    @(posedge hclk) #1;
    htrans = 2'd3; haddr = {haddr[31:2],haddr[1:0] + 1'b1}; hwdata = {$random}%1024;
    for(i=0;i<2;i=i+1) begin
      @(posedge hclk) #1;
      htrans = 2'd3; haddr = {haddr[31:2],haddr[1:0] + 1'b1}; hwdata = {$random}%1024;
      #1; @(posedge hclk);
    end
    @(posedge hclk) #1;
    hwrite = 0; htrans = 2'd0; hwdata = {$random}%1024; haddr = 32'h0000_0000;
  end
  endtask

  task burst_read_wrap4();
  begin
    @(posedge hclk) #1;
    hwrite = 0; hsize = 1; hburst = 3'd2; htrans = 2'd2;
    hreadyin = 1; haddr = 32'h8000_0056;
    @(posedge hclk) #1;
    htrans = 2'd3; haddr = {haddr[31:3],haddr[2:1] + 1'b1,haddr[0]}; hwdata = {$random}%128;
    for(i=0;i<2;i=i+1) begin
      @(posedge hclk) #1;
      htrans = 2'd3; haddr = {haddr[31:3],haddr[2:1] + 1'b1,haddr[0]}; hwdata = {$random}%128;
      #1; @(posedge hclk);
    end
    @(posedge hclk) #1;
    hwrite = 0; htrans = 2'd0; hwdata = {$random}%128; haddr = 32'h0000_0000;
  end
  endtask
endmodule
