function A=rewsoftthr(E,t,weights);

A=(E-t.*weights).*((E-t.*weights)>0)+(E+t.*weights).*((E+t.*weights)<0);