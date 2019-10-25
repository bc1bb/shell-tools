grep "Failed password" /var/log/auth.log | \
# grep only failed password
cut -d' ' -f4 --complement | \
# delete fourth word (I find it useless)
sed 's/ port /:/' | \
# change ' port ' by ':', easier to read
sed s/'\w*$'// |
# delete last word (it is useless too)
tac  > /var/www/html/ggwp
# reverse the lines then post it on beefs.tech/ggwp :)

# Example line :
# Oct 25 11:01:46 sshd[12202]: Failed password for invalid user webmaster from 213.32.28.162:32972 
# (yes that's a real line from my output)
