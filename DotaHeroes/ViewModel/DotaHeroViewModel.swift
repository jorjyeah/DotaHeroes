//
//  DotaHeroViewModel.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 07/06/22.
//

import Foundation

class DotaHeroViewModel {
    var dotaHeroes: [DotaHero] = []
    private var apiCall: APICall = APICall()
    
    func fetchData(completion :@escaping ([DotaHero]) -> Void){
        self.apiCall.getDataHeroes { data, response, error in
            if let data = data {
                self.dotaHeroes = data
                completion(self.dotaHeroes)
            }
        }
    }
}
