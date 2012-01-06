//
//  CLSynchronizeIngredients.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 06.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLSynchronizeIngredients.h"
#import "CLAppDelegate.h"
#import "CLIngredient.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation CLSynchronizeIngredients

- (void)requestFinished:(ASIHTTPRequest*) request {
  NSManagedObjectContext *managedObjectContext = [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
  
  // Select all existing ingredients
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Ingredient" inManagedObjectContext:managedObjectContext];
  
  [fetchRequest setEntity:entityDescription];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES]]];
  
  NSError *error = nil;
  NSArray *currIngredients = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  // Now handle the received data and add it to core data
  NSArray *ingredients = [[request responseString] JSONValue];
  
  for(NSDictionary *ingrDict in ingredients) {
    NSNumber *identifier = [NSNumber numberWithDouble:[[ingrDict objectForKey:CL_API_JSON_IDKEY] doubleValue]];
    NSString *name = [ingrDict objectForKey:CL_API_JSON_NAMEKEY];
    
    bool create = YES;
    for(CLIngredient *currIngr in currIngredients) {
      if([identifier isEqualToNumber:[currIngr identifier]]) {
        create = NO;
        break;
      }
    }
    
    if (create) {
      CLIngredient *ingr = (CLIngredient *)[NSEntityDescription insertNewObjectForEntityForName:@"Ingredient"
                                                                         inManagedObjectContext:managedObjectContext];
      ingr.identifier = identifier;
      ingr.name = name;
    }
  }
  
  [managedObjectContext save:&error];
  if (error != nil) {
    NSLog(@"Error saving data");
  }
  
  [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] setDidSynchronizeIngredients:YES];
  
  NSLog(@"Finished updating ingredients");
}

- (void)requestFailed:(ASIHTTPRequest*) request {
  NSLog(@"Synchronize ingredients request failed");
}

@end
