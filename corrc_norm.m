function [cc] = corrc_norm(sig_ref, sig_test)
cc_num = sum(sig_ref .* sig_test);
cc_den = sqrt(sum(sig_ref .* sig_ref) * sum(sig_test .* sig_test));
cc = cc_num / cc_den;