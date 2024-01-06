module hockey(

    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   
    
    );
    
    reg [4:0] state;
    reg turn;
    reg [1:0]p;
    reg [7:0] timer;
    reg [2:0] AScore, BScore;
    reg [1:0] DIR_A, DIR_B;
    reg [2:0] X_COORD, Y_COORD;
    
    parameter IDLE = 0, DISP = 1, HIT_A = 2, HIT_B = 3, SEND_A = 4, SEND_B = 5, RESP_A = 6, RESP_B = 7, GOAL_A = 8, GOAL_B = 9, END_ = 10;
    parameter A = 7'b0001000, b = 7'b1100000, zero = 7'b0000001, one = 7'b1001111 ,two = 7'b0010010, three = 7'b0000110, four = 7'b1001100, hyphen = 7'b1111110, empty = 7'b1111111;
    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= IDLE;
            X_COORD <= 0;
            Y_COORD <= 0;
            AScore <= 0;
            BScore <= 0;
            timer <= 0;
        end
        else
        begin 
            case(state)
                IDLE:
                    if(BTNA)
                    begin 
                        turn <= 0;
                        state <= DISP;
                    end
                    else if(BTNB)
                    begin 
                        turn <= 1;
                        state <= DISP;
                    end
                DISP:
                    if(timer < 100)
                    begin
                        timer <= timer+1;
                        state <= DISP;
                    end
                    else
                    begin
                        timer <= 0;
                        if(turn == 0)
                        begin
                            state <= HIT_A;
                        end
                        else
                        begin
                            state <= HIT_B;
                        end
                    end
                HIT_A:
                    if(BTNA && YA < 5)
                    begin
                        X_COORD <= 0;
                        Y_COORD <= YA;
                        DIR_A <= DIRA;
                        state <= SEND_B;
                    end
                    else
                    begin
                        state <= HIT_A;
                    end
                HIT_B:
                    if(BTNB && YB < 5)
                    begin
                        X_COORD <= 4;
                        Y_COORD <= YB;
                        DIR_B <= DIRB;
                        state <= SEND_A;
                    end
                    else
                    begin
                        state <= HIT_B;
                    end
                SEND_A:
                    if(timer < 100)
                    begin
                        timer <= timer+1;
                        state <= SEND_A;
                    end
                    else
                    begin
                        timer <= 0;
                        if(DIR_B != 0)
                        begin
                            if(Y_COORD == 3'd4)
                            begin
                                Y_COORD <= 3'd3;
                                DIR_B <= 2'b10;
                            end
                            else if(Y_COORD == 3'd0)
                            begin
                                Y_COORD <= 3'd1;
                                DIR_B <= 2'b01;
                            end
                            else
                            begin
                                if(DIR_B == 2'b01)
                                begin
                                    Y_COORD <= Y_COORD + 1;
                                end
                                else //if(DIR_B == 2'b10)
                                begin
                                    Y_COORD <= Y_COORD - 1;
                                end
                            end
                        end
                        else 
                        begin
                            Y_COORD <= Y_COORD;
                        end
                        if(X_COORD > 1)
                        begin
                            X_COORD <= X_COORD - 1;
                            state <= SEND_A;
                        end
                        else
                        begin
                            X_COORD <= 0;
                            state <= RESP_A;
                        end
                    end
                SEND_B:
                    if(timer < 100)
                    begin
                        timer <= timer+1;
                        state <= SEND_B;
                    end
                    else
                    begin
                        timer <= 0;
                        if(DIR_A != 0)
                        begin
                            if(Y_COORD == 3'd4)
                            begin
                                Y_COORD <= 3'd3;
                                DIR_A <= 2'b10;
                            end
                            else if(Y_COORD == 3'd0)
                            begin
                                Y_COORD <= 3'd1;
                                DIR_A <= 2'b01;
                            end
                            else
                            begin
                                if(DIR_A == 2'b01)
                                begin
                                    Y_COORD <= Y_COORD + 1;
                                end
                                else //if(DIR_A == 2'b10)
                                begin
                                    Y_COORD <= Y_COORD - 1;
                                end
                            end
                        end
                        else
                        begin
                            Y_COORD <= Y_COORD;
                        end
                        if(X_COORD < 3)
                        begin
                            X_COORD <= X_COORD + 1;
                            state <= SEND_B;
                        end
                        else
                        begin
                            X_COORD <= 4;
                            state <= RESP_B;
                        end
                    end
                RESP_A:
                    if(timer < 100)
                    begin
                        if(BTNA && Y_COORD == YA)
                        begin
                            X_COORD <= 1;
                            timer <= 0;
                            if(DIRA != 0)
                            begin
                                if(Y_COORD == 3'd4)
                                begin
                                    Y_COORD <= 3'd3;
                                    DIR_A <= 2'b10;
                                end
                                else if(Y_COORD == 3'd0)
                                begin
                                    Y_COORD <= 3'd1;
                                    DIR_A <= 2'b01;
                                end
                                else
                                begin
                                    if(DIRA == 2'b01)
                                    begin
                                        Y_COORD <= Y_COORD + 1;
                                    end
                                    else //if(DIRA == 2'b10)
                                    begin
                                        Y_COORD <= Y_COORD - 1;
                                    end
                                    DIR_A <= DIRA;
                                end
                            end
                            else
                            begin
                                Y_COORD <= Y_COORD;
                                DIR_A <= DIRA;
                            end
                            state <= SEND_B;
                        end
                        else
                        begin
                            timer <= timer+1;
                            state <= RESP_A;
                        end
                    end
                    else
                    begin
                        timer <= 0;
                        BScore <= BScore+1;
                        state <= GOAL_B;
                    end
                RESP_B:
                    if(timer < 100)
                    begin
                        if(BTNB && Y_COORD == YB)
                        begin
                            X_COORD <= 3;
                            timer <= 0;
                            if(DIRB != 0)
                            begin
                                if(Y_COORD == 3'd4)
                                begin
                                    Y_COORD <= 3'd3;
                                    DIR_B <= 2'b10;
                                end
                                else if(Y_COORD == 3'd0)
                                begin
                                    Y_COORD <= 3'd1;
                                    DIR_B <= 2'b01;
                                end
                                else
                                begin
                                    if(DIRB == 2'b01)
                                    begin
                                        Y_COORD <= Y_COORD + 1;
                                    end
                                    else //if(DIRB == 2'b10)
                                    begin
                                        Y_COORD <= Y_COORD - 1;
                                    end
                                    DIR_B <= DIRB;
                                end
                            end
                            else
                            begin
                                Y_COORD <= Y_COORD;
                                DIR_B <= DIRB;
                            end
                            state <= SEND_A;
                        end
                        else
                        begin
                            timer <= timer+1;
                            state <= RESP_B;
                        end
                    end
                    else
                    begin
                        timer <= 0;
                        AScore <= AScore+1;
                        state <= GOAL_A;
                    end
                GOAL_A:
                    if(timer < 100)
                    begin
                        timer <= timer+1;
                        state <= GOAL_A;
                    end
                    else
                    begin
                        timer <= 0;
                        if(AScore == 3)
                        begin
                            turn <= 0;
                            state <= END_;
                        end
                        else
                        begin
                            state <= HIT_B;
                        end
                    end
                GOAL_B:
                    if(timer < 100)
                    begin
                        timer <= timer+1;
                        state <= GOAL_B;
                    end
                    else
                    begin
                        timer <= 0;
                        if(BScore == 3)
                        begin
                            turn <= 1;
                            state <= END_;
                        end
                        else
                        begin
                            state <= HIT_A;
                        end
                    end
                END_:
                begin
                    if(timer < 50)
                    begin
                        p <= 1;
                        timer <= timer + 1;
                    end
                    else if(timer >= 50 && timer < 100)
                    begin
                        p <= 2;
                        timer <= timer + 1;
                    end
                    else
                    begin 
                        timer <= 0;
                    end
                    state <= END_;
                end
                default:
                    state <= IDLE;
            
            endcase     
                
        end
    
    end
    
    // for SSDs
    always @ (*)
    begin
        case(state)
            IDLE:
            begin
                SSD2 = A;
                SSD1 = hyphen;
                SSD0 = b;
                SSD3 = empty;
                SSD4 = empty;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                
            end    
            DISP:
            begin
                SSD1 = hyphen;
                if(AScore == 3)
                    SSD2 = three;
                else if(AScore == 2)
                    SSD2 = two;
                else if(AScore == 1)
                    SSD2 = one;
                else //if(AScore == 0)
                    SSD2 = zero;
                if(BScore == 3)
                    SSD0 = three;
                else if(BScore == 2)
                    SSD0 = two;
                else if(BScore == 1)
                    SSD0 = one;
                else //if(BScore == 0)
                    SSD0 = zero;
                    
                
                SSD3 = empty;
                SSD4 = empty;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
            end
            HIT_A:
            begin 
                if(YA == 4)
                    SSD4 = four;
                else if(YA == 3)
                    SSD4 = three;
                else if(YA == 2)
                    SSD4 = two;
                else if(YA == 1)
                    SSD4 = one;
                else if(YA == 0)
                    SSD4 = zero;
                else
                    SSD4 = hyphen;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                SSD0 = empty;
                SSD1 = empty;
                SSD2 = empty;
                SSD3 = empty;
            end
                
            HIT_B:
            begin 
                if(YB == 4)
                    SSD4 = four;
                else if(YB == 3)
                    SSD4 = three;
                else if(YB == 2)
                    SSD4 = two;
                else if(YB == 1)
                    SSD4 = one;
                else if(YB == 0)
                    SSD4 = zero;
                else
                    SSD4 = hyphen;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                SSD0 = empty;
                SSD1 = empty;
                SSD2 = empty;
                SSD3 = empty;
            end
            SEND_A:
            begin 
                if(Y_COORD == 4)
                    SSD4 = four;
                else if(Y_COORD == 3)
                    SSD4 = three;
                else if(Y_COORD == 2)
                    SSD4 = two;
                else if(Y_COORD == 1)
                    SSD4 = one;
                else //if(Y_COORD == 0)
                    SSD4 = zero;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                SSD0 = empty;
                SSD1 = empty;
                SSD2 = empty;
                SSD3 = empty;
            end
            SEND_B:
            begin 
                if(Y_COORD == 4)
                    SSD4 = four;
                else if(Y_COORD == 3)
                    SSD4 = three;
                else if(Y_COORD == 2)
                    SSD4 = two;
                else if(Y_COORD == 1)
                    SSD4 = one;
                else //if(Y_COORD == 0)
                    SSD4 = zero;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                SSD0 = empty;
                SSD1 = empty;
                SSD2 = empty;
                SSD3 = empty;
            end
            RESP_A:
            begin 
                if(Y_COORD == 4)
                    SSD4 = four;
                else if(Y_COORD == 3)
                    SSD4 = three;
                else if(Y_COORD == 2)
                    SSD4 = two;
                else if(Y_COORD == 1)
                    SSD4 = one;
                else //if(Y_COORD == 0)
                    SSD4 = zero;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                SSD0 = empty;
                SSD1 = empty;
                SSD2 = empty;
                SSD3 = empty;
            end
            RESP_B:
            begin 
                if(Y_COORD == 4)
                    SSD4 = four;
                else if(Y_COORD == 3)
                    SSD4 = three;
                else if(Y_COORD == 2)
                    SSD4 = two;
                else if(Y_COORD == 1)
                    SSD4 = one;
                else //if(Y_COORD == 0)
                    SSD4 = zero;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
                SSD0 = empty;
                SSD1 = empty;
                SSD2 = empty;
                SSD3 = empty;
            end
            GOAL_A:
            begin
                SSD1 = hyphen;
                if(AScore == 3)
                    SSD2 = three;
                else if(AScore == 2)
                    SSD2 = two;
                else if(AScore == 1)
                    SSD2 = one;
                else //if(AScore == 0)
                    SSD2 = zero;
                
                if(BScore == 3)
                    SSD0 = three;
                else if(BScore == 2)
                    SSD0 = two;
                else if(BScore == 1)
                    SSD0 = one;
                else //if(BScore == 0)
                    SSD0 = zero;
                SSD3 = empty;
                SSD4 = empty;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
            end
            GOAL_B:
            begin
                SSD1 = hyphen;
                if(AScore == 3)
                    SSD2 = three;
                else if(AScore == 2)
                    SSD2 = two;
                else if(AScore == 1)
                    SSD2 = one;
                else //if(AScore == 0)
                    SSD2 = zero;
                
                if(BScore == 3)
                    SSD0 = three;
                else if(BScore == 2)
                    SSD0 = two;
                else if(BScore == 1)
                    SSD0 = one;
                else //if(BScore == 0)
                    SSD0 = zero;
                SSD3 = empty;
                SSD4 = empty;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
            end
            END_:
            begin
                if(AScore == 3)
                    SSD4 = A;
                else //if(BScore == 3)
                    SSD4 = b;
                SSD1 = hyphen;
                if(AScore == 3)
                    SSD2 = three;
                else if(AScore == 2)
                    SSD2 = two;
                else if(AScore == 1)
                    SSD2 = one;
                else //if(AScore == 0)
                    SSD2 = zero;
                
                if(BScore == 3)
                    SSD0 = three;
                else if(BScore == 2)
                    SSD0 = two;
                else if(BScore == 1)
                    SSD0 = one;
                else //if(BScore == 0)
                    SSD0 = zero;
                SSD3 = empty;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
            end
            default:
            begin
                SSD2 = A;
                SSD1 = hyphen;
                SSD0 = b;
                SSD3 = empty;
                SSD4 = empty;
                SSD5 = empty;
                SSD6 = empty;
                SSD7 = empty;
            end

        endcase

    end
    
    //for LEDs
    always @ (*)
    begin
        case(state)
            IDLE:
            begin
                LEDA = 1;
                LEDB = 1;
                LEDX = 5'b00000;
            end
            DISP:
            begin
                LEDX = 5'b11111;
                LEDA = 0;
                LEDB = 0;
            end
            HIT_A:
            begin
                LEDA = 1;
                LEDX = 5'b00000;
                LEDB = 0;
            end
            HIT_B:
            begin
                LEDB = 1;
                LEDA = 0;
                LEDX = 5'b00000;
            end
            SEND_A:
            begin 
                if(X_COORD == 4)
                    LEDX = 5'b00001;
                else if(X_COORD == 3)
                    LEDX = 5'b00010;
                else if(X_COORD == 2)
                    LEDX = 5'b00100;
                else //if(X_COORD == 1)
                    LEDX = 5'b01000;
                LEDA = 0;
                LEDB = 0;
            end
            SEND_B:
            begin 
                if(X_COORD == 3)
                    LEDX = 5'b00010;
                else if(X_COORD == 2)
                    LEDX = 5'b00100;
                else if(X_COORD == 1)
                    LEDX = 5'b01000;
                else //if(X_COORD == 0)
                    LEDX = 5'b10000;
                LEDA = 0;
                LEDB = 0;
            end
            RESP_A:
            begin
                
                LEDX = 5'b10000;
                LEDA = 1;
                LEDB = 0;
            end
            RESP_B:
            begin
                
                LEDX = 5'b00001;
                LEDB = 1;
                LEDA = 0;
            end
            GOAL_A:
            begin
                LEDX = 5'b11111;
                LEDA = 0;
                LEDB = 0;
            end
            GOAL_B:
            begin
                LEDX = 5'b11111;
                LEDA = 0;
                LEDB = 0;
            end
            END_:
            begin
                case(p)
                    1:
                    begin
                        LEDX = 5'b10101;
                        LEDA = 0;
                        LEDB = 0;
                    end
                    
                    2:
                    begin
                        LEDX = 5'b01010;
                        LEDA = 0;
                        LEDB = 0;
                    end
                    default:
                    begin
                        LEDX = 5'b10101;
                        LEDA = 0;
                        LEDB = 0;
                    end
                    
                endcase
               
                    
            end
            default:
            begin
                LEDA = 1;
                LEDB = 1;
                LEDX = 5'b00000;
            end
                
        endcase
      
    
    end
    
    
endmodule
