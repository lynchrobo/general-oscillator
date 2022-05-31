syms Kp T Fo I a1 a2 a3 L

sys_dSA = [0 1 0 0;
          -Kp/(I*T^2) 0 Fo/(I*T) 0;
          0 0 0 1;
          0 -a1/(L*T) -a3 -a2];
      
simplify(charpoly(sys_dSA))