def adv_gets(cli)
    msg = ""
    sleep (0.001)
    while cli.ready?
        msg += cli.getc
    end
    msg
end