Benchmarking
============

## Sample benchmarking routines:

These tests were done in our rpclab and are just preliminary raw test results. We had 5 boxes running Ubuntu 16.04 each with an Intel Xeon E5-2640 CPU, 64GB of RAM, and with 45 3TB spinning hard drives and 2 1TB SSD drives. SSDs were used for account and container information and the regular drives were used for object data. It's important to note that we tested on empty systems and it is known that performance will decline the more full the cluster becomes. Further testing should be done on full systems but obviously such tests will take signifcantly more time.

### 4KB

```
export KEYSTONE=1.2.3.4:5000
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-put    -containers 100 -count 10000000 -size 4096    -csv bench4KBput1.csv    bench-ec-kb-1-       2>&1 | tee big-test-ec-kb-put-1-
sleep 300
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-put    -containers 100 -count 10000000 -size 4096    -csv bench4KBput2.csv    bench-ec-kb-2-       2>&1 | tee big-test-ec-kb-put-2-
sleep 900
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-get    -containers 100 -count 10000000 -iterations 3 -csv bench4KBget1.csv    bench-ec-kb-1-       2>&1 | tee big-test-ec-kb-get-1-
sleep 300
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-get    -containers 100 -count 10000000 -iterations 3 -csv bench4KBget2.csv    bench-ec-kb-2-       2>&1 | tee big-test-ec-kb-get-2-
sleep 900
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-delete -containers 100 -count 10000000               -csv bench4KBdelete1.csv bench-ec-kb-1-       2>&1 | tee big-test-ec-kb-delete-1-
sleep 300
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-delete -containers 100 -count 10000000               -csv bench4KBdelete2.csv bench-ec-kb-2-       2>&1 | tee big-test-ec-kb-delete-2-
sleep 900
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 50  bench-mixed  -containers 100      -size 4096 -time 2h      -csv bench4KBmixed1.csv  bench-ec-kb-mixed-2- 2>&1 | tee big-test-ec-kb-mixed-1-
```

Results:

4970 PUT/s - https://transfer.sh/KIKEH/4KB_put_1strun.txt  
2193 PUT/s - https://transfer.sh/WW7eF/4KB_put_2ndrun.txt  
17162 GET/s - https://transfer.sh/xN71C/4KB_get_1strun.txt  
20718 GET/s - https://transfer.sh/9p6Vk/4KB_get_2ndrun.txt  
7183 DELETE/s - https://transfer.sh/MAbFd/4KB_delete_1strun.txt  
7380 DELETE/s - https://transfer.sh/sv21h/4KB_delete_2ndrun.txt  
7405 mixed/s - https://transfer.sh/8ONBL/4KB_mixed.txt  

### 1MB

```
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-put    -containers 100 -count 1000000 -size 1048576 -csv bench1MBput1.csv bench-ec-mb-1-         2>&1 | tee big-test-ec-mb-put-1-
sleep 300
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-put    -containers 100 -count 1000000 -size 1048576 -csv bench1MBput2.csv bench-ec-mb-2-         2>&1 | tee big-test-ec-mb-put-2-
sleep 900
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-get    -containers 100 -count 1000000 -iterations 3 -csv bench1MBget1.csv bench-ec-mb-1-         2>&1 | tee big-test-ec-mb-get-1-
sleep 300
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-get    -containers 100 -count 1000000 -iterations 3 -csv bench1MBget2.csv bench-ec-mb-2-         2>&1 | tee big-test-ec-mb-get-2-
sleep 900
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-delete -containers 100 -count 1000000               -csv bench1MBdelete1.csv bench-ec-mb-1-      2>&1 | tee big-test-ec-mb-delete-1-
sleep 300
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 250 bench-delete -containers 100 -count 1000000               -csv bench1MBdelete2.csv bench-ec-mb-2-      2>&1 | tee big-test-ec-mb-delete-2-
sleep 900
nectar -continue-on-error -A http://${KEYSTONE}/v3/ -T test -U tester -P testing -C 50  bench-mixed  -containers 100    -size 1048576 -time 2h    -csv bench1MBmixed1.csv bench-ec-mb-mixed-2- 2>&1 | tee big-test-ec-mb-mixed-1-
```

Results:

720 PUT/s - https://transfer.sh/SXyIy/1MB_put_1strun.txt  
719 PUT/s - https://transfer.sh/1ovpN/1MB_put_2ndrun.txt  
898 GET/s - https://transfer.sh/z1Mco/1MB_get_1strun.txt  
898 GET/s - https://transfer.sh/JR2pI/1MB_get_2ndrun.txt  
7042 DELETE/s - https://transfer.sh/k7cpE/1MB_delete_1strun.txt  
7246 DELETE/s - https://transfer.sh/a8MxA/1MB_delete_2ndrun.txt  
4044 mixed/s - https://transfer.sh/rSkgB/1MB_mixed.txt  

## Comparison to other object stores

### Here are same preliminary tests against the same environment running Openstack Swift

### 4KB

Results:

594 PUT/s -  
470 PUT/s -  
2909 GET/s -  
2913 GET/s -  
856 DELETE/s  
682 DELETE/s  
2907 mixed/s  

### 1MB

182 PUT/s -  
184 PUT/s -  
811 GET/s -  
816 GET/s -  
511 DELETE/s  
542 DELETE/s  
2897 mixed/s  
