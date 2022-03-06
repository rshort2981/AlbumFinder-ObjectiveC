//
//  ViewController.m
//  AlbumFinder
//
//  Created by Robert Short on 1/5/22.
//

#import "ViewController.h"
#import "Album.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<Album *> *albums;

@end

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAlbums];
    
    self.navigationItem.title = @"Albums";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
    
    [self getAlbums];
}

- (void)getAlbums {
    NSLog(@"Fetching Albums");

    NSString *urlString = @"https://itunes.apple.com/search?term=Nirvana&attribute=artistTerm&entity=album";
    NSURL *url = [NSURL URLWithString:urlString];

    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"Fetched Albums");
        
        NSError *err;
        NSDictionary *albumJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            NSLog(@"Error: %@", err);
            return;
        }


 NSArray *results = [[NSArray alloc] initWithObjects:[albumJSON objectForKey:@"results"], nil];
//        NSString *name = [results valueForKey:@"collectionName"];
//        Album *album = Album.new;
//        album.collectionName = name;
//
//        NSMutableArray *albums = NSMutableArray.new;
//        [albums addObject:album];
//
//        self.albums = albums;
//
//
//        NSLog(@"%@", self.albums);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//           [self.tableView reloadData];
//        });
        
        NSMutableArray<Album *> *albums = NSMutableArray.new;
        for (results in albumJSON) {
            NSString *name = [results valueForKey:@"collectionName"];
            Album *album = Album.new;
            album.collectionName = name;
            [albums addObject:album];
        }
        
        self.albums = albums;
        
        NSLog(@"%@", self.albums);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
        
        }] resume];
}

- (void)setupAlbums {
    self.albums = NSMutableArray.new;
    
    Album *album = Album.new;
    album.collectionName = @"Nevermind";
    [self.albums addObject:album];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    Album *album = self.albums[indexPath.row];
    
    cell.textLabel.text = album.collectionName;
    return cell;
}

@end
