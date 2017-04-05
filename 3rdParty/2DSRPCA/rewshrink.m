function A=rewshrink(D,t,weights);

[U S V]=svd(D);
A=U*rewsoftthr(S,t,weights)*V';