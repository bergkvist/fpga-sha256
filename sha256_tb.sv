module sha256_tb;
    logic [511:0] message;
    logic [255:0] digest;
    sha256 _sha256(.message(message), .digest(digest));

    logic [255:0] expected;
    initial begin
        message = {{55{8'h31}}, 8'h80, 64'h00000000000001b8};
        expected = 256'h31f713cc_40a632a9_ce454b30_29b727e9_bb6d0eea_11460f1d_7818852c_2565b9cd;
        #1 assert (digest == expected) $display("SHA256 OK\n",
            "Message:      %h %h %h %h %h %h %h %h\n",  message[511 -:32],  message[479 -:32],  message[447 -:32],  message[415 -:32],  message[383 -:32],  message[351 -:32],  message[319 -:32],  message[287 -:32],
            "              %h %h %h %h %h %h %h %h\n",  message[255 -:32],  message[223 -:32],  message[191 -:32],  message[159 -:32],  message[127 -:32],  message[ 95 -:32],  message[ 63 -:32],  message[ 31 -:32],
            "Digest:       %h %h %h %h %h %h %h %h\n",   digest[255 -:32],   digest[223 -:32],   digest[191 -:32],   digest[159 -:32],   digest[127 -:32],   digest[ 95 -:32],   digest[ 63 -:32],   digest[ 31 -:32]
        );
        else $error("SHA256 MISMATCH:\n",
            "Message:      %h %h %h %h %h %h %h %h\n",  message[511 -:32],  message[479 -:32],  message[447 -:32],  message[415 -:32],  message[383 -:32],  message[351 -:32],  message[319 -:32],  message[287 -:32],
            "              %h %h %h %h %h %h %h %h\n",  message[255 -:32],  message[223 -:32],  message[191 -:32],  message[159 -:32],  message[127 -:32],  message[ 95 -:32],  message[ 63 -:32],  message[ 31 -:32],
            "Digest:       %h %h %h %h %h %h %h %h\n",   digest[255 -:32],   digest[223 -:32],   digest[191 -:32],   digest[159 -:32],   digest[127 -:32],   digest[ 95 -:32],   digest[ 63 -:32],   digest[ 31 -:32],
            "Expected:     %h %h %h %h %h %h %h %h\n", expected[255 -:32], expected[223 -:32], expected[191 -:32], expected[159 -:32], expected[127 -:32], expected[ 95 -:32], expected[ 63 -:32], expected[ 31 -:32]
        );
    end
endmodule
