//
//  VolumeDetailViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 03/10/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//


import Foundation
import RxSwift
import ComicContainer
import ComicService

protocol VolumeDetailViewModelType: class {

    /// Determines if the volume is saved in the user's comic list
    var isSaved: Observable<Bool> { get }

    /// The volume info
    var volume: Volume { get }

    /// The volume description
    var about: Observable<String?> { get }

    /// The issues for this volume
    var issues: Observable<[Issue]> { get }

    /// Adds or removes the volume from the user's comic list
    func addOrRemove()
}

// FIXME: This is a mock implementation
final class VolumeDetailViewModel: VolumeDetailViewModelType {

    var isSaved: Observable<Bool> {
        return saved.asObservable()
    }

    private(set) var volume: Volume

	private(set) lazy var about: Observable<String?> = self.client.object(forResource: API.description(volumeIdentifier: self.volume.identifier))
		.map { (value: VolumeDescription) -> String? in
			return value.description
		}
		.startWith("")
		.observeOn(MainScheduler.instance)

	private(set) lazy var issues: Observable<[Issue]> = self.client.objects(forResource: API.issues(volumeIdentifier: self.volume.identifier))
		.observeOn(MainScheduler.instance)
	
	
	private let container: VolumeContainerType
	private let client: Client
	private let saved: Variable<Bool>
	
	init(volume: Volume, container: VolumeContainerType = VolumeContainer.instance, client: Client = Client()) {
        self.volume = volume
		self.container = container
		self.client = client
		self.saved = Variable(container.contains(volumeWithIdentifier: volume.identifier))
		
    }

    func addOrRemove() {
		let observable: Observable<Void>
		
		if saved.value {
			observable = container.delete(volumeWithIdentifier: volume.identifier)
		} else {
			observable = container.save(volumes: [volume])
		}
		
		let _ = observable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: {
			self.saved.value = !self.saved.value
		})
		
    }
}
