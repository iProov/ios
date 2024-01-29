/*
 
 IPTSKPublicKeyAlgorithm.h
 TrustKit
 
 Copyright 2015 The TrustKit Project Authors
 Licensed under the MIT license, see associated LICENSE file for terms.
 See AUTHORS file for the list of project authors.
 
 */

#ifndef IPTSKPublicKeyAlgorithm_h
#define IPTSKPublicKeyAlgorithm_h

#if __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

// The internal enum we use for public key algorithms; not to be confused with the exported TSKSupportedAlgorithm
typedef NS_ENUM(NSInteger, IPTSKPublicKeyAlgorithm)
{
    // Some assumptions are made about this specific ordering in public_key_utils.m
    IPTSKPublicKeyAlgorithmRsa2048 = 0,
    IPTSKPublicKeyAlgorithmRsa4096 = 1,
    IPTSKPublicKeyAlgorithmEcDsaSecp256r1 = 2,
    IPTSKPublicKeyAlgorithmEcDsaSecp384r1 = 3,
    
    IPTSKPublicKeyAlgorithmLast = IPTSKPublicKeyAlgorithmEcDsaSecp384r1
} __deprecated_msg("Starting with TrustKit 1.6.0, key algorithms no longer need to be specified; remove IPTSKPublicKeyAlgorithms from your configuration.");

#endif /* IPTSKPublicKeyAlgorithm_h */
