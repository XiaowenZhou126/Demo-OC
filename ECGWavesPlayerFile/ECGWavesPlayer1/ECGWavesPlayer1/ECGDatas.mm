//
//  ECGDatas.m
//  ECGWavesPlayer1
//
//  Created by mac on 2017/5/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ECGDatas.h"

@implementation ECGDatas

+ (short **)getDemoData:(int)length
{
    short p[3][500] = {{48,53,53,57,53,53,48,57,53,43,53,57,53,53,48,47,47,42,52,52,51,51,51,41,51,41,46,55,60,51,50,45,50,54,54,54,54,50,54,50,50,45,45,50,50,49,53,53,49,39,43,48,52,57,57,57,57,62,62,67,71,81,81,76,76,81,90,90,100,110,120,120,125,125,139,143,138,143,138,133,128,123,137,142,137,142,147,137,142,137,136,127,122,117,102,87,73,73,58,58,58,53,58,58,53,43,33,38,38,38,42,46,42,46,37,37,37,37,42,42,41,41,36,31,36,31,36,45,31,21,11,2,2,6,16,59,88,118,152,201,273,366,458,570,663,741,785,761,697,634,487,350,238,160,96,18,-49,-74,-74,-74,-49,-35,-44,-25,-15,-2,-2,-2,-2,-2,-3,-3,1,1,6,6,11,16,26,21,30,30,30,39,44,49,54,44,44,44,44,39,44,54,59,63,58,53,53,58,52,62,62,62,57,57,52,57,57,62,61,66,61,66,61,66,61,61,71,71,66,71,71,71,75,74,79,84,79,89,88,78,83,93,98,98,93,103,103,98,102,102,102,112,121,121,126,126,126,131,136,141,146,151,151,150,150,154,154,164,173,173,168,178,168,173,178,178,183,188,187,182,177,172,177,172,172,172,167,162,157,148,148,143,138,142,132,122,117,112,107,102,102,97,92,92,92,87,82,82,76,71,76,76,71,66,62,62,62,57,62,62,62,62,52,56,56,51,56,61,60,60,55,55,60,55,55,60,64,64,63,44,54,54,59,59,59,54,59,54,54,54,54,59,59,58,53,53,48,53,52,52,57,57,47,52,47,47,42,47,56,56,46,46,41,46,46,46,46,51,51,46,46,46,51,50,55,45,50,55,49,39,49,49,54,58,58,54,58,49,43,53,53,53,48,48,57,53,43,53,57,57,53,53,53,47,42,47,52,47,55,55,55,60,51,46,51,51,55,65,59,54,50,50,50,50,50,54,54,54,50,45,54,54,50,53,58,58,63,49},
        {50,66,71,90,75,61,41,51,46,56,71,85,80,71,56,51,51,56,75,80,85,85,66,51,56,56,66,71,96,86,72,52,57,57,67,86,96,86,81,67,57,57,62,76,76,91,81,62,47,57,57,62,76,91,81,78,59,69,74,98,127,147,147,132,118,113,103,103,122,127,142,137,137,147,171,166,181,191,205,191,166,147,152,138,143,153,153,128,114,89,89,70,60,84,89,94,79,65,40,36,31,40,40,50,50,40,11,16,11,21,38,47,42,33,13,8,3,13,28,33,38,28,13,-1,8,13,28,28,23,-1,-49,-98,-123,-147,-147,-157,-171,-215,-258,-307,-336,-341,-307,-253,-229,-175,-126,-78,-63,14,107,117,78,92,43,-43,-97,-112,-122,-73,-24,29,82,112,117,128,133,148,177,187,182,153,114,80,75,75,84,89,114,84,80,45,26,21,36,45,65,45,36,21,26,16,21,46,61,56,42,27,12,12,17,32,42,61,46,37,12,17,12,27,37,46,32,32,27,22,17,17,37,42,48,44,29,14,14,19,34,34,53,39,29,14,19,14,29,39,53,48,44,29,24,24,29,48,58,63,53,40,35,35,40,59,64,79,69,64,45,59,54,69,84,88,79,79,69,69,74,74,88,98,103,98,84,69,74,76,95,100,110,100,90,71,76,76,86,100,110,100,86,66,66,56,61,81,86,86,76,66,51,47,51,66,72,87,67,52,33,43,38,43,57,82,67,52,38,38,33,43,57,67,72,67,52,43,38,43,62,67,82,72,54,35,50,50,59,69,84,69,54,40,45,45,50,64,69,74,64,54,40,40,40,64,69,79,64,50,30,31,31,46,55,70,60,51,31,31,31,36,51,60,60,55,41,31,31,41,60,65,80,65,55,41,46,46,55,72,87,72,67,48,43,43,48,67,72,72,67,48,33,33,43,67,62,77,53,43,43,53,43,53,67,82,73,68,44,39,39,49,73,78,78,73,58,44,39,44,63,63,78,68,58,34,39,39,49,54,78,83,68,50},
        {3,4,4,-6,4,4,4,-6,-1,-1,-1,-1,-1,-1,4,-6,-6,-1,-6,-1,-5,-9,-5,-5,-9,-9,-9,-5,-9,-9,-9,-5,-9,-5,-9,-9,-9,-9,-9,-9,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-3,-3,8,8,18,23,23,13,13,13,3,3,-6,3,3,-2,-6,-6,-6,-6,-25,-30,-47,-62,-62,-47,-52,-52,-62,-72,-72,-62,-67,-52,-52,-57,-43,-43,-38,-38,-38,-33,-27,-27,-17,-27,-32,-32,-27,-32,-27,-32,-27,-27,-22,-27,-22,-27,-27,-22,-22,-17,-20,-20,-15,-15,-20,-10,-15,-1,3,33,72,121,135,121,86,62,47,72,111,174,244,273,258,204,117,-53,-224,-361,-561,-751,-907,-1039,-1107,-1195,-1224,-1185,-1137,-1058,-976,-912,-827,-720,-554,-442,-368,-320,-271,-232,-193,-144,-115,-95,-80,-61,-46,-27,-27,-7,-7,11,27,27,32,37,32,32,32,37,42,42,32,46,51,46,46,46,46,51,51,51,53,53,58,53,58,63,63,63,73,68,73,68,73,78,73,68,78,83,78,87,84,84,88,93,93,98,98,113,108,113,123,123,118,128,128,142,142,152,157,157,154,169,173,173,183,183,188,193,198,208,217,212,222,222,227,232,242,237,247,247,253,248,253,257,253,253,257,257,253,248,248,248,243,238,233,233,223,223,209,199,196,181,172,162,147,142,128,118,113,103,89,89,74,64,64,54,50,45,40,35,41,31,31,21,26,26,26,16,21,12,16,12,16,16,12,12,12,12,12,12,14,14,14,5,14,14,14,14,5,14,14,14,14,14,14,14,14,14,14,14,6,15,15,15,15,15,15,15,15,15,15,15,19,15,15,19,19,15,19,15,21,17,21,21,26,26,26,26,26,26,26,26,26,21,21,21,17,26,17,17,18,22,18,22,18,22,18,18,18,18,18,18,22,18,18,18,18,22,18,18,20,20,20,20,20,20,11,6,20,11,20,6,11,6,6,6,6,6,1,6,7,12,7,2,2,7,-3,2,2,7,12,12,7,21,12,21,2,2,2,3},
    };
    
    
    short **data = new short*[length];
    
    for (int i=0; i<length; i++)
    {
        data[i] = new short[8];
        for (int j=0; j<3; j++)
        {
            data[i][j] = p[j][i];
        }
    }	
    
    return data;
}

@end
