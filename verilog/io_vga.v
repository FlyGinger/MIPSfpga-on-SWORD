// Author: Jiang Zengkai
// Date: 2019.4.9

module io_vga(
    input clk, //25MHz
    input clr, //clear, active high
    input [11:0] rgb, //rrrr_gggg_bbbb
    output reg [9:0] h_addr, //horizontal address
    output reg [8:0] v_addr, //vertical address
    output reg read, //active high
    output reg VGA_HS, //horizontal synchronization
    output reg VGA_VS, //vertical synchronization
    output reg [3:0] VGA_R, //red
    output reg [3:0] VGA_G, //green
    output reg [3:0] VGA_B); //blue
    
    //VGA horizontal counter
    //total:800 (0-799)
    //SP:   96  (0-95)
    //BP:   48  (96-143)
    //HV:   640 (144-783)
    //FP:   16  (784-799)
    reg [9:0] h_count;
    always @ (posedge clk or posedge clr) begin
        if (clr) begin
            h_count <= 10'b0;
        end
        else if (h_count == 10'd799) begin
            h_count <= 10'b0;
        end
        else begin
            h_count <= h_count + 10'b1;
        end
    end
    
    //VGA vertical counter
    //total:521 (0-520)
    //SP:   2   (0-1)
    //BP:   29  (2-30)
    //VV:   480 (31-510)
    //FP:   10  (511-520)
    reg [9:0] v_count;
    always @ (posedge clk or posedge clr) begin
        if (clr) begin
            v_count <= 10'b0;
        end
        else begin
            if (h_count ==10'd799) begin
                if (v_count == 10'd520) begin
                    v_count <= 10'b0;
                end
                else begin
                    v_count <= v_count + 10'b1;
                end
            end
        end
    end
        
    //relays
    wire [9:0] h_addr_relay = h_count - 10'd144;
    wire [9:0] v_addr_relay = v_count - 10'd31;
    wire hsync_relay = (h_count > 10'd95);
    wire vsync_relay = (v_count > 10'd1);
    wire read_relay = (h_count > 10'd143) && (h_count < 10'd784) && (v_count > 10'd30) && (v_count < 10'd511);
    
    //output
    always @ (posedge clk) begin
        h_addr <= h_addr_relay;
        v_addr <= v_addr_relay[8:0];
        VGA_HS <= hsync_relay;
        VGA_VS <= vsync_relay;
        read <= read_relay;
        VGA_R <= read ? rgb[11:8] : 4'b0;
        VGA_G <= read ? rgb[7:4] : 4'b0;
        VGA_B <= read ? rgb[3:0] : 4'b0;
    end
    
endmodule