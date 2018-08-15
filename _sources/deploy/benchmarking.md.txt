Benchmarking
============

### 4KB Test script

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
```

### 1MB Test Script

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
```

# Results from Old Hummingbird lab.
## Sample benchmarking routines:

These tests were done in our rpclab and are just preliminary raw test results. We had 5 boxes running Ubuntu 16.04 each with an Intel Xeon E5-2640 CPU, 64GB of RAM, and with 45 3TB spinning hard drives and 2 1TB SSD drives. SSDs were used for account and container information and the regular drives were used for object data. It's important to note that we tested on empty systems and it is known that performance will decline the more full the cluster becomes. Further testing should be done on full systems but obviously such tests will take signifcantly more time.


### 4 KB Objects:

| 4 KB 5 nodes Results    | Hummingbird | Ceph | Swift |
|-------------------------|-------------|------|-------|
| PUT/sec first round     | 4970        | 1397 | 594   |
| PUT/sec second round    | 2193        | 1362 | 470   |
| GET/sec first round     | 17162       | 3230 | 2909  |
| GET/sec second round    | 20718       | 2832 | 2913  |
| DELETE/sec first round  | 7183        | 1208 | 856   |
| DELETE/sec second round | 7380        | 936  | 682   |


## 1 MB Objects:

| 1 MB 5 nodes Results    | Hummingbird | Ceph | Swift |
|-------------------------|-------------|------|-------|
| PUT/sec first round     | 720         | 685  | 182   |
| PUT/sec second round    | 719         | 777  | 184   |
| GET/sec first round     | 898         | 955  | 811   |
| GET/sec second round    | 898         | 953  | 816   |
| DELETE/sec first round  | 7042        | 1647 | 511   |
| DELETE/sec second round | 7246        | 1552 | 542   |


# Results from the New Hummingbird Lab

## Lab configuration
```
Model: HP DL380 Gen9 LFF - 3.5" Chassis
Processor: Dual Socket Octo Core Intel Xeon E5-2630 2.40 Ghz
Memory: 128 GB
Onboard NIC: HP 561-T Dual Port 10GbE Base-T PCIe NIC (RJ-45)
Additional NIC: HP 561-T Dual Port 10GbE Base-T PCIe NIC (RJ-45)
Drives: 2x 600 GB SAS(OS), 10x 960GB SSD (MU)
RAID Adapter: PMC 8885Q (IT Mode)

(5) JBODs, loaded with the following disk drive configuration:
JBOD: 1x Supermicro 45 Bay
45x 10TB SATA Drives in SuperMicro JBOD
```


## 5 Nodes Test results

We ran the same set of 4KB & 1MB benchtests mentioned above.

### 4 KB objects

| 4 KB 5 nodes Results    | Hummingbird | Ceph | Swift |
|-------------------------|-------------|------|-------|
| PUT/sec first round     | 10395       | 3525 | 890   |
| PUT/sec second round    | 8985        | 5764 | 928   |
| GET/sec first round     | 16207       | 8576 | 4208  |
| GET/sec second round    | 16146       | 8058 | 4407  |
| DELETE/sec first round  | 9225        | 5440 | 656   |
| DELETE/sec second round | 9157        | 5316 | 517   |


### 1 MB objects

| 1MB 5 nodes Results     | Hummingbird | Ceph | Swift |
|-------------------------|-------------|------|-------|
| PUT/sec first round     | 820         | 778  | 477   |
| PUT/sec second round    | 862         | 781  | 492   |
| GET/sec first round     | 818         | 619  | 602   |
| GET/sec second round    | 855         | 694  | 760   |
| DELETE/sec first round  | 9434        | 6211 | 512   |
| DELETE/sec second round | 9709        | 6410 | 433   |


## 4 Nodes Test Results

### 4 KB objects

| 4KB 4 nodes Results     | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 9625        | 5027 |
| PUT/sec second round    | 7062        | 4014 |
| GET/sec first round     | 12931       | 4780 |
| GET/sec second round    | 12815       | 4726 |
| DELETE/sec first round  | 6770        | 3878 |
| DELETE/sec second round | 7097        | 3834 |

### 1 MB objects

| 1 MB 4 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 807         | 759  |
| PUT/sec second round    | 798         | 765  |
| GET/sec first round     | 795         | 745  |
| GET/sec second round    | 779         | 677  |
| DELETE/sec first round  | 5747        | 4065 |
| DELETE/sec second round | 7299        | 4032 |


# Results from Ceph Performance lab

## Lab Configuration
```
HARDWARE
========
Chassis - Proliant DL380 Gen9
CPU     - 2 x Intel Xeon E5-2630 8 core 2.4GHz
Memory  - 8 x 16GB DIMM DDR4 2133 MHz
NIC     - HP FlexFabric 10Gb 2-port 533FLR-T NIC Firmware 7.14.79
            - Broadcom NetXtreme II BCM57810
RAID    - P440ar RAID Controller Firmware 5.04
            - HPE 12G SAS Expander Card
DISKS   - OS RAID 1   - 2 x 600GB HDD
          OSDs RAID 0 - 24 x SATA SSD Model MK0960GFDKT Firmware HPG0
```

## 6 Nodes Results

We ran the same set of 4KB & 1MB benchtests mentioned above.

### 4 KB objects

| 4 KB 6 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 14045       | 7168 |
| PUT/sec second round    | 13263       | 5650 |
| GET/sec first round     | 20576       | 5821 |
| GET/sec second round    | 24896       | 5810 |
| DELETE/sec first round  | 14662       | 5319 |
| DELETE/sec second round | 15083       | 5120 |

### 1 MB objects

| 1 MB 6 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 1173        | 1172 |
| PUT/sec second round    | 1172        | 1174 |
| GET/sec first round     | 1170        | 1169 |
| GET/sec second round    | 1170        | 1169 |
| DELETE/sec first round  | 16393       | 5555 |
| DELETE/sec second round | 16667       | 5882 |

## 5 Nodes Results

### 4 KB objects

| 4 KB 5 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 12136       | 6257 |
| PUT/sec second round    | 12255       | 4909 |
| GET/sec first round     | 27002       | 5725 |
| GET/sec second round    | 24671       | 5723 |
| DELETE/sec first round  | 12210       | 4456 |
| DELETE/sec second round | 12870       | 4306 |

### 1 MB objects

| 1 MB 5 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 1173        | 1172 |
| PUT/sec second round    | 1173        | 1172 |
| GET/sec first round     | 1170        | 1169 |
| GET/sec second round    | 1169        | 1169 |
| DELETE/sec first round  | 12500       | 4926 |
| DELETE/sec second round | 13698       | 4902 |

## 4 Nodes Results

### 4 KB objects

| 4 KB 4 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 10070       | 4610 |
| PUT/sec second round    | 9832        | 3892 |
| GET/sec first round     | 18963       | 5482 |
| GET/sec second round    | 22779       | 5379 |
| DELETE/sec first round  | 10427       | 3551 |
| DELETE/sec second round | 10121       | 3454 |

### 1 MB objects

| 1 MB 4 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 1172        | 1170 |
| PUT/sec second round    | 1173        | 1172 |
| GET/sec first round     | 1170        | 1169 |
| GET/sec second round    | 1170        | 1168 |
| DELETE/sec first round  | 10204       | 4032 |
| DELETE/sec second round | 10416       | 3831 |



# Results from Ceph Capacity lab

## Lab Configuration
```
HARDWARE
========
Chassis - Proliant DL380 Gen9
CPU     - 2 x Intel Xeon E5-2630 8 core 2.4GHz
Memory  - 8 x 16GB DIMM DDR4 2133 MHz
NIC     - HP FlexFabric 10Gb 2-port 533FLR-T NIC Firmware 7.14.65
            - Broadcom NetXtreme II BCM57810
RAID    - P840 RAID Controller Firmware 5.04
DISKS   - OS RAID 1      - 2 x 600GB HDD
          Journal RAID 0 – 2 x SATA SSD Model MK0960GFDKT Firmware HPG0
          OSDs RAID 0    – 8 x SATA HDD Model MB010000GWAYN Firmware HPG3
```

## 6 Nodes Results

### 4 KB objects

| 4 KB 6 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 10917       | 5503 |
| PUT/sec second round    | 5073        | 3985 |
| GET/sec first round     | 21171       | 3380 |
| GET/sec second round    | 19569       | 3731 |
| DELETE/sec first round  | 5455        | 3235 |
| DELETE/sec second round | 5356        | 3850 |

### 1 MB objects

| 1 MB 6 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 975         | 1170 |
| PUT/sec second round    | 807         | 1170 |
| GET/sec first round     | 1170        | 1168 |
| GET/sec second round    | 1170        | 1169 |
| DELETE/sec first round  | 2557        | 5128 |
| DELETE/sec second round | 5988        | 5747 |

## 5 Nodes Results

### 4 KB objects

| 4 KB 5 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 8347        | 4407 |
| PUT/sec second round    | 3624        | 3288 |
| GET/sec first round     | 15592       | 3267 |
| GET/sec second round    | 18382       | 3566 |
| DELETE/sec first round  | 3717        | 2734 |
| DELETE/sec second round | 3847        | 3136 |

### 1 MB objects

| 1 MB 5 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 750         | 1169 |
| PUT/sec second round    | 664         | 1168 |
| GET/sec first round     | 1169        | 1168 |
| GET/sec second round    | 1170        | 1169 |
| DELETE/sec first round  | 3236        | 4032 |
| DELETE/sec second round | 4587        | 4424 |

## 4 Nodes Results

### 4 KB objects

| 4 KB 4 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 6250        | 3511 |
| PUT/sec second round    | 2642        | 2755 |
| GET/sec first round     | 10706       | 3028 |
| GET/sec second round    | 16313       | 3124 |
| DELETE/sec first round  | 2388        | 2280 |
| DELETE/sec second round | 2590        | 2646 |

### 1 MB objects

| 1 MB 4 nodes Results    | Hummingbird | Ceph |
|-------------------------|-------------|------|
| PUT/sec first round     | 1129        | 1164 |
| PUT/sec second round    | 933         | 1162 |
| GET/sec first round     | 701         | 1169 |
| GET/sec second round    | 964         | 1169 |
| DELETE/sec first round  | 9174        | 3424 |
| DELETE/sec second round | 8620        | 3636 |
