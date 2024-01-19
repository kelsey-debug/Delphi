//
//  Delphi
//
//Created by Kelsey Larson on 11/8/23.
//responsible for creating embeddings, vectors, and direct contain to LangChain index

import Foundation
import PineconeSwift
import LangChain

class LangChainManagement {
    
    var pinecone = PineconeSwift(apikey: Enviroment.pineconeKey,
                                 baseURL: Enviroment.pineconebaseURL)
    var userStorage = UserStorage.shared

    //create langchain embedding from input, query pinecone vectors
    func queryIndex(newQuery: String) async -> [String] {
        var IndexData = ""
        var queryResult = [PineconeVector]()
        let embed = await createEmbeddings(Query: newQuery)
        do {
            queryResult = try await pinecone.queryVectors(with: embed,
                                                          namespace: "",
                                                          topK: 3,
                                                          includeMetadata: true)
        }
        catch {
            print(error)
        }
        var queryStringList = [String]()
        for elem in queryResult {
            queryStringList.append(elem.metadata.queryValue)
        }
        return queryStringList
    }
    
    //queryString -> langChain embedding
    func createEmbeddings (Query: String) async -> EmbedResult {
        let embeddingTech = OpenAIEmbeddings()
        let vector = await embeddingTech.embedQuery(text: Query)
        embeddingTech.shutdown()
        let vectorConform = vector.map { Double($0) }
        let embed = EmbedResult(index: 1, embedding: vectorConform, text: Query)
        return embed
    }
    
}
