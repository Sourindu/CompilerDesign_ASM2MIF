ENTITY d_ff IS -- Example flip-flop
PORT(clk, d     :IN bit;
     q          :OUT bit);
END;

ARCHITECTURE fpga OF d_ff IS
BEGIN
P1: PROCESS (clk)
  BEGIN
     WAIT UNTIL clk='1';  --> gives always FF
       q <= d;               
  END PROCESS;
END fpga;
