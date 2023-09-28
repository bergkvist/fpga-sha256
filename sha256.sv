`define rotr32(x, S) ((x >> S) | (x << (32 - S)))
`define maj(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
`define ch(x, y, z)  (((x) & (y)) ^ (~(x) & (z)))
`define sigma0(x) (`rotr32(x,  7) ^ `rotr32(x, 18) ^ (x >> 3))
`define sigma1(x) (`rotr32(x, 17) ^ `rotr32(x, 19) ^ (x >> 10))
`define Sigma0(x) (`rotr32(x,  2) ^ `rotr32(x, 13) ^ `rotr32(x, 22))
`define Sigma1(x) (`rotr32(x,  6) ^ `rotr32(x, 11) ^ `rotr32(x, 25))

module sha256(
    input logic [511:0] message,
    output logic [255:0] digest
);
    genvar i;
    localparam logic [2047:0] K256 = {
        32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
        32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
        32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
        32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
        32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
        32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
        32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
        32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
    };
    logic [2079:0] a, b, c, d, e, f, g, h;
    logic [2047:0] schedule, t1;

    assign digest[255 -:32] = a[2079-:32] + a[0 +:32];
    assign digest[223 -:32] = b[2079-:32] + b[0 +:32];
    assign digest[191 -:32] = c[2079-:32] + c[0 +:32];
    assign digest[159 -:32] = d[2079-:32] + d[0 +:32];
    assign digest[127 -:32] = e[2079-:32] + e[0 +:32];
    assign digest[ 95 -:32] = f[2079-:32] + f[0 +:32];
    assign digest[ 63 -:32] = g[2079-:32] + g[0 +:32];
    assign digest[ 31 -:32] = h[2079-:32] + h[0 +:32];

    // Initial state
    assign a[2079-:32] = 32'h6a09e667;
    assign b[2079-:32] = 32'hbb67ae85;
    assign c[2079-:32] = 32'h3c6ef372;
    assign d[2079-:32] = 32'ha54ff53a;
    assign e[2079-:32] = 32'h510e527f;
    assign f[2079-:32] = 32'h9b05688c;
    assign g[2079-:32] = 32'h1f83d9ab;
    assign h[2079-:32] = 32'h5be0cd19;
    assign schedule[2047 -:512] = message[511:0];
    
    generate for (i = 0; i < 64; i++)
        assign a[2047-32*i -:32] = t1[2047-32*i -:32] + `Sigma0(a[2079-32*i -:32]) + `maj(a[2079-32*i -:32], b[2079-32*i -:32], c[2079-32*i -:32]);
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign b[2047-32*i -:32] = a[2079-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign c[2047-32*i -:32] = b[2079-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign d[2047-32*i -:32] = c[2079-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign e[2047-32*i -:32] = d[2079-32*i -:32] + t1[2047-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign f[2047-32*i -:32] = e[2079-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign g[2047-32*i -:32] = f[2079-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign h[2047-32*i -:32] = g[2079-32*i -:32];
    endgenerate

    generate for (i = 0; i < 64; i++)
        assign t1[2047-32*i -:32] = (h[2079-32*i -:32] + `Sigma1(e[2079-32*i -:32]) + `ch(e[2079-32*i -:32], f[2079-32*i -:32], g[2079-32*i -:32]) +
                                     K256[2047-32*i -:32] + schedule[2047-32*i -:32]);
    endgenerate

    generate for (i = 16; i < 64; i++)
        assign schedule[2047 - 32*i -:32] = (`sigma1(schedule[2047 - 32*(i- 2) -:32]) + schedule[2047 - 32*(i- 7) -:32] +
                                             `sigma0(schedule[2047 - 32*(i-15) -:32]) + schedule[2047 - 32*(i-16) -:32]);
    endgenerate

endmodule
