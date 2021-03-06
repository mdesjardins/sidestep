//
//  ProxySetter.m
//  Sidestep
//
//  Created by Chetan Surpur on 11/18/10.
//  Copyright 2010 Chetan Surpur. All rights reserved.
//

#import "ProxySetter.h"
#import "AppUtilities.h"


@implementation ProxySetter

/*
 *	Switches Airport's SOCKS proxy to the SSH tunnel previously opened.
 *	
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnAirportProxyOn:(NSNumber *)port {
    
    return [self turnProxyOn:port interface:@"Airport"];

}

/*
 *	Switches WiFi's SOCKS proxy to the SSH tunnel previously opened.
 *	
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnWiFiProxyOn:(NSNumber *)port {
    
    return [self turnProxyOn:port interface:@"Wi-Fi"];
    
}

/*
 *	Switches given interface's SOCKS proxy to the SSH tunnel previously opened.
 *	
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnProxyOn:(NSNumber *)port interface:(NSString *)interface {
	
	XLog(self, @"Turning proxy on for port: %@", port);
	
	NSTask *task = [[[NSTask alloc] init] autorelease];
	
	// Setup the pipes on the task
	NSPipe *outputPipe = [NSPipe pipe];
	NSPipe *errorPipe = [NSPipe pipe];
	
	[task setStandardOutput:outputPipe];
	[task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
	[task setStandardError:errorPipe];
	
	// Set up arguments to the task
	NSArray *args = [NSArray arrayWithObjects:	[NSString stringWithString:interface],
												[NSString stringWithFormat:@"%d", [port intValue]],
												nil];
	
	// Get the path of the task, which is included as part of the main application bundle
	NSString *taskPath = [NSBundle pathForResource:@"TurnProxyOn"
											ofType:@"sh"
									   inDirectory:[[NSBundle mainBundle] bundlePath]];
	
	if (!taskPath) {
		return FALSE;
	}
	
	// Set task's arguments and launch path
	[task setArguments:args];
	[task setLaunchPath:taskPath];
	
	// Launch task
	[task launch];
	
	return TRUE;
	
}

/*
 *	Switches Airport's SOCKS proxy off.
 *	
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnAirportProxyOff {
	
    return [self turnProxyOff:@"Airport"];
    
}

/*
 *	Switches WiFi's SOCKS proxy off.
 *	
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnWiFiProxyOff {
	
    return [self turnProxyOff:@"Wi-Fi"];
    
}

/*
 *	Switches given interface's SOCKS proxy off.
 *	
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnProxyOff:(NSString *)interface {

	XLog(self, @"Turning proxy off");
	
	NSTask *task = [[[NSTask alloc] init] autorelease];
	
	// Setup the pipes on the task
	NSPipe *outputPipe = [NSPipe pipe];
	NSPipe *errorPipe = [NSPipe pipe];
	
	[task setStandardOutput:outputPipe];
	[task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
	[task setStandardError:errorPipe];
	
	// Set up arguments to the task
	NSArray *args = [NSArray arrayWithObject:[NSString stringWithString:interface]];	
	
	// Get the path of the task, which is included as part of the main application bundle
	NSString *taskPath = [NSBundle pathForResource:@"TurnProxyOff"
											ofType:@"sh"
									   inDirectory:[[NSBundle mainBundle] bundlePath]];
	
	if (!taskPath) {
		return FALSE;
	}	
	
	// Set task's arguments and launch path
	[task setArguments:args];
	[task setLaunchPath:taskPath];
	
	// Launch task
	[task launch];
	
	return TRUE;
	
}

@end
