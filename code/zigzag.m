% Javier Salazar Andrew Bouasry
% ZigZag scan for 8x8 blocks or 1x64 arrays
% Usage: input array or matrix and specify forward or inverse by 0,1
function output = zigzag(input, option)
if (option == 0) % forward
    output = zeros(1, 64, class(input)); % preallocate array
    output(1)=input(1,1); % manually define locations of matrix to array
    output(2)=input(1,2); % cumbersome but most efficient for strictly 8x8
    output(3)=input(2,1); % as opposed to building higher computation cost generic algorithm
    output(4)=input(3,1);
    output(5)=input(2,2);
    output(6)=input(1,3);
    output(7)=input(1,4);
    output(8)=input(2,3);
    output(9)=input(3,2);
    output(10)=input(4,1);
    output(11)=input(5,1);
    output(12)=input(4,2);
    output(13)=input(3,3);
    output(14)=input(2,4);
    output(15)=input(1,5);
    output(16)=input(1,6);
    output(17)=input(2,5);
    output(18)=input(3,4);
    output(19)=input(4,3);
    output(20)=input(5,2);
    output(21)=input(6,1);
    output(22)=input(7,1);
    output(23)=input(6,2);
    output(24)=input(5,3);
    output(25)=input(4,4);
    output(26)=input(3,5);
    output(27)=input(2,6);
    output(28)=input(1,7);
    output(29)=input(1,8);
    output(30)=input(2,7);
    output(31)=input(3,6);
    output(32)=input(4,5);
    output(33)=input(5,4);
    output(34)=input(6,3);
    output(35)=input(7,2);
    output(36)=input(8,1);
    output(37)=input(8,2);
    output(38)=input(7,3);
    output(39)=input(6,4);
    output(40)=input(5,5);
    output(41)=input(4,6);
    output(42)=input(3,7);
    output(43)=input(2,8);
    output(44)=input(3,8);
    output(45)=input(4,7);
    output(46)=input(5,6);
    output(47)=input(6,5);
    output(48)=input(7,4);
    output(49)=input(8,3);
    output(50)=input(8,4);
    output(51)=input(7,5);
    output(52)=input(6,6);
    output(53)=input(5,7);
    output(54)=input(4,8);
    output(55)=input(5,8);
    output(56)=input(6,7);
    output(57)=input(7,6);
    output(58)=input(8,5);
    output(59)=input(8,6);
    output(60)=input(7,7);
    output(61)=input(6,8);
    output(62)=input(7,8);
    output(63)=input(8,7);
    output(64)=input(8,8); 
else % for inverse zigzag
    output = zeros(8,8,class(input)); % preallocate matrix
    output(1,1)=input(1); % manually defined relationship as shown above
    output(1,2)=input(2);
    output(2,1)=input(3);
    output(3,1)=input(4);
    output(2,2)=input(5);
    output(1,3)=input(6);
    output(1,4)=input(7);
    output(2,3)=input(8);
    output(3,2)=input(9);
    output(4,1)=input(10);
    output(5,1)=input(11);
    output(4,2)=input(12);
    output(3,3)=input(13);
    output(2,4)=input(14);
    output(1,5)=input(15);
    output(1,6)=input(16);
    output(2,5)=input(17);
    output(3,4)=input(18);
    output(4,3)=input(19);
    output(5,2)=input(20);
    output(6,1)=input(21);
    output(7,1)=input(22);
    output(6,2)=input(23);
    output(5,3)=input(24);
    output(4,4)=input(25);
    output(3,5)=input(26);
    output(2,6)=input(27);
    output(1,7)=input(28);
    output(1,8)=input(29);
    output(2,7)=input(30);
    output(3,6)=input(31);
    output(4,5)=input(32);
    output(5,4)=input(33);
    output(6,3)=input(34);
    output(7,2)=input(35);
    output(8,1)=input(36);
    output(8,2)=input(37);
    output(7,3)=input(38);
    output(6,4)=input(39);
    output(5,5)=input(40);
    output(4,6)=input(41);
    output(3,7)=input(42);
    output(2,8)=input(43);
    output(3,8)=input(44);
    output(4,7)=input(45);
    output(5,6)=input(46);
    output(6,5)=input(47);
    output(7,4)=input(48);
    output(8,3)=input(49);
    output(8,4)=input(50);
    output(7,5)=input(51);
    output(6,6)=input(52);
    output(5,7)=input(53);
    output(4,8)=input(54);
    output(5,8)=input(55);
    output(6,7)=input(56);
    output(7,6)=input(57);
    output(8,5)=input(58);
    output(8,6)=input(59);
    output(7,7)=input(60);
    output(6,8)=input(61);
    output(7,8)=input(62);
    output(8,7)=input(63);
    output(8,8)=input(64); 
end
end
 