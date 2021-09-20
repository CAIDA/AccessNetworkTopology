
# create the prefix2as from AS Rank's file
python3 convert_prefix2as.py > prefix2as.txt
python3 convert_prefix2as.py -v 6 > prefix2as6.txt

# You are going to need to change from AS links to ip links lines 58-68
# create mapping between link and the destination that saw it
python3 build-link-dsts.py > link_dsts.txt
python3 build-link-dsts.py -v 6 > link_dsts6.txt

# sort destination by the number of new links added.
python3  best-destinations.py link_dsts.txt > dst_num_links.txt
python3  best-destinations.py link_dsts6.txt > dst_num_links6.txt
