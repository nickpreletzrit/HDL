-- 1. state register (clocked)
process (clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            state <= S_IDLE;
        else
            state <= next_state;
        end if;
    end if;
end process;

-- 2. next-state logic (combinational)
process (all)
begin
    next_state <= state;
    case state is
        when S_IDLE =>
            if btn_pulse = '1' then
                next_state <= S_LOAD;
            end if;
        when S_LOAD   => next_state <= S_RUN;
        when S_RUN    => if done = '1' then next_state <= S_FINISH; end if;
        when S_FINISH => next_state <= S_IDLE;
    end case;
end process;

-- 3. output logic (combinational, depends only on state = Moore)
process (all)
begin
    busy <= '0';
    case state is
        when S_LOAD | S_RUN => busy <= '1';
        when others         => null;
    end case;
end process;