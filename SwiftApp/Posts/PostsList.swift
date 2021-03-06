//
//  PostsList.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct PostsList: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var addNewPost = false
    @State var editPost = false
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                       ascending: false)],
    animation: .default)
    
    var postList: FetchedResults<PostEntity>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("えらいリスト")
                .font(.title)
                
                Calender()
                Spacer()
                Button(action: {
                    self.addNewPost = true
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }.sheet(isPresented: $addNewPost) {
                    PostsNew()
                        .environment(\.managedObjectContext, self.viewContext)
                }
                

            }
            .padding(10)
            
            ScrollView(.vertical, showsIndicators: false){
                ForEach(postList, id: \.self){ post in
                    
                    PostRow(post: post)
                    
                }
            }
            
            
        }
        
    }

        
}

struct PostsList_Previews: PreviewProvider {
    

    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static let context = container.viewContext
    
    static var previews: some View {
        // テストデータの全削除
    let request = NSBatchDeleteRequest(
       fetchRequest: NSFetchRequest(entityName: "PostEntity"))
    try! container.persistentStoreCoordinator.execute(request, with: context)
        
    // データを追加
    PostEntity.create(in: context,
                     content: "筋トレをした！", detail: "腹筋10回", rate: 3)
    PostEntity.create(in: context,
    content: "バイトをした！!", detail: "一万円稼いだ", rate: 3)
    PostEntity.create(in: context,
                      content: "運動した", detail: "ちょっと歩いた", rate: 3)
    PostEntity.create(in: context,
    content: "勉強した！", detail: "英検一級合格まで頑張ろう", rate: 3)
        return PostsList()
            .environment(\.managedObjectContext, context)
            
        
    }
}
