module APB_controller(hclk,hresetn,hwrite,hwrite_reg,valid,haddr,haddr1,haddr2,hwdata,hwdata1,hwdata2,
                         prdata,tempselx,pwrite,penable,pselx,paddr,pwdata,hreadyout);
input hclk, hresetn, hwrite;
input hwrite_reg, valid;
input [31:0] haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2;
input [31:0] prdata;
input [2:0] tempselx;
output reg penable, pwrite, hreadyout;
output reg [31:0] paddr, pwdata;
output reg [2:0] pselx;
reg penable_temp, pwrite_temp, hreadyout_temp;
reg [2:0] pselx_temp;
reg [31:0] paddr_temp, pwdata_temp;
parameter ST_IDLE=3'b000, ST_WWAIT=3'b001, ST_WRITEP=3'b010, ST_WRITE=3'b011,
          ST_WENABLE=3'b100, ST_WENABLEP=3'b101, ST_READ=3'b110, ST_RENABLE=3'b111;
reg [2:0] present, next;
always @(posedge hclk) begin
  if(!hresetn) present <= ST_IDLE;
  else present <= next;
end
always @(*) begin
  next = ST_IDLE;
  case(present)
    ST_IDLE: if(valid && hwrite) next=ST_WWAIT; else if(valid && ~hwrite) next=ST_READ; else next=ST_IDLE;
    ST_WWAIT: if(valid) next=ST_WRITEP; else next=ST_WRITE;
    ST_WRITE: if(valid) next=ST_WENABLEP; else next=ST_WENABLE;
    ST_WRITEP: next=ST_WENABLEP;
    ST_WENABLE: if(valid && hwrite) next=ST_WWAIT; else if(valid && ~hwrite) next=ST_READ; else next=ST_IDLE;
    ST_WENABLEP: if(valid && hwrite_reg) next=ST_WRITEP; else if(~valid && hwrite_reg) next=ST_WRITE; else next=ST_READ;
    ST_READ: next=ST_RENABLE;
    ST_RENABLE: if(valid && hwrite) next=ST_WWAIT; else if(valid && ~hwrite) next=ST_READ; else next=ST_IDLE;
    default: next=ST_IDLE;
  endcase
end
always @(*) begin
  case(present)
    ST_IDLE: begin
      if(valid && hwrite) begin pselx_temp=3'b0; penable_temp=1'b0; hreadyout_temp=1'b1; end
      else if(valid && ~hwrite) begin paddr_temp=haddr; pwrite_temp=1'b0; pselx_temp=tempselx; hreadyout_temp=1'b0; penable_temp=1'b0; end
    end
    ST_WWAIT: begin paddr_temp=haddr1; pwrite_temp=1'b1; pselx_temp=tempselx; hreadyout_temp=1'b0; pwdata_temp=hwdata; end
    ST_WRITE: begin hreadyout_temp=1'b1; penable_temp=1'b1; end
    ST_WRITEP: begin penable_temp=1'b1; hreadyout_temp=1'b1; end
    ST_WENABLEP: begin paddr_temp=haddr2; penable_temp=1'b0; pwdata_temp=hwdata; hreadyout_temp=1'b0; end
    ST_WENABLE: begin penable_temp=1'b1; hreadyout_temp=1'b1; end
    ST_READ: begin hreadyout_temp=1'b1; penable_temp=1'b1; end
    ST_RENABLE: begin paddr_temp=haddr; hreadyout_temp=1'b0; penable_temp=1'b0; end
  endcase
end
always @(posedge hclk) begin
  if(!hresetn) begin pselx<=0; penable<=0; pwdata<=0; hreadyout<=1'b1; end
  else begin paddr<=paddr_temp; pwrite<=pwrite_temp; pselx<=pselx_temp; penable<=penable_temp; pwdata<=pwdata_temp; hreadyout<=hreadyout_temp; end
end
endmodule
