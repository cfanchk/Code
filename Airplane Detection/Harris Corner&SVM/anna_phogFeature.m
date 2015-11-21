function p = anna_phogFeature(bh,bv,L,roi,bin)
bh_roi = bh(roi(1,1):roi(2,1),roi(3,1):roi(4,1));
bv_roi = bv(roi(1,1):roi(2,1),roi(3,1):roi(4,1));
p = anna_phogDescriptor(bh_roi,bv_roi,L,bin);