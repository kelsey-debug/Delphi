//
//  LangChainClient.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/31/23.
//AIClient responsible for training model, making requests

import Foundation
import UIKit
import NIO
import SwiftUI
import LangChain
import AsyncHTTPClient

//class == reference, struct == copies created
struct langViewtest: View {
    
    var body: some View {
        NavigationView {
          LangChainClient()
        }
    }
}

//class LangChainClient: ObservableObject {
struct LangChainClient: View {
    //    static let shared = LangChainClient() //singleton instance for lifespan
    
    var body: some View {
        VStack {
            Text(output)
                .padding()
                .onAppear {
                    performOperations(userMessage: "Hi there", previousMessages: [""])
                }
        }
    }
    
    @State private var output: String = ""
    
    func performOperations(userMessage: String, previousMessages: [String]) //need to add a completion handler here to return result ot inputVM
    {
        
        let template =
        """
           You are an expert at the field of dream analysis and interpretation. You strive to give the user understanding on the dream in their concious life, and also understanding of their unconcious minds choices. Your goal is to help deepen someones understanding in the way they think and function, through the understanding of their dreams. Use the dream that is described to help the user. Use previous components of the conversation to modify the conversation as it flows. {human_input} {history}"
        """
        let prompt = PromptTemplate(input_variables: ["history", "human_input"],
                                    partial_variable: [:],
                                    template: template)
        Vectorize()
    }
    
    func Vectorize () {
        Task {
            let documentString = ModifyFile()
            let textSplitter = CharacterTextSplitter(chunk_size: 2000, chunk_overlap: 200)
            let splitText  = textSplitter.split_text(text: documentString)
            print("chunk count", splitText.count)
            let embeddings = OpenAIEmbeddings() //uses Ada
            let vector = await embeddings.embedQuery(text: splitText.first!)
            print("resulting vector 🌈:", vector)
        }
    }
    
    func ModifyFile () -> String {
        let filePath = "Jungtextlonger.txt"
        let nameAndExt = filePath.split(separator: ".")
        let name = "\(nameAndExt[0])"
        let ext = "\(nameAndExt[1])"
        var moddedData = ""
        if let res = Bundle.main.path(forResource: name, ofType: ext) {
            do {
                var text = try String(contentsOfFile: res)
                moddedData = text.replacingOccurrences(of: "\n", with: "\n\n")
            } catch {
                print("cant retrieve string contents of file")
            }
        }else {
            print("file DNE")
        }
        return moddedData
    }
}

/*
this sounds like I need to make a few steps.

1. Create a vector storage of my data in openAI.
2. create a template that has to do with dream anaylsis, how many words I want, tone, and the dynamic {input} to consider.
3.  Take inputted question, do a vector similarity search
4. Use result from vector similarity search + the original question in an LLM search.
5. profit from result
 
 
 MORE INFO:
 now that I have the vectors embedded via a POST to openAI, how can I upload them permanently to open AI so I can reference the stored vectors, instead of requesting EACH TIME?
 Ill need to create a class thats sole duty is to train and upload vectors. This will need to use a multitude of resources.
*/

        /*
        let chatgpt_chain = LLMChain(
            llm: OpenAI(),
            prompt: prompt,
            memory: ConversationBufferWindowMemory()
        )
       
        // call loadandSplit to get my data into vector
        Task {
            var input = userMessage
            var res = await chatgpt_chain.predict(args: ["human_input": input])
            print("MY INPUT:" + input)
            print("API🌈:" + res)
            output = res
        }*/
    /* let template = """
        Assistant is a large language model trained by OpenAI.
        
        ...
        {history}
        Human: {human_input}
        Assistant:
        """*/

    ///requests API
    ////TODO: make async, non view
    ///func request(userMessage: String, previousMessages: [String], onCompletion: (Result<Chat,APIErrorResponse>) -> Void) async {
    
   // func performOperations(userMessage: String, previousMessages: [String], onCompletion: (Result<Chat,APIErrorResponse>) -> Void )
/*let testString = """
                        Madam Speaker, Madam Vice President, our First Lady and Second Gentleman. Members of Congress and the Cabinet. Justices of the Supreme Court. My fellow Americans.

                        Last year COVID-19 kept us apart. This year we are finally together again.

                        Tonight, we meet as Democrats Republicans and Independents. But most importantly as Americans.

                        With a duty to one another to the American people to the Constitution.

                        And with an unwavering resolve that freedom will always triumph over tyranny.

                        Six days ago, Russia’s Vladimir Putin sought to shake the foundations of the free world thinking he could make it bend to his menacing ways. But he badly miscalculated.

                        He thought he could roll into Ukraine and the world would roll over. Instead he met a wall of strength he never imagined.

                        He met the Ukrainian people.

                        From President Zelenskyy to every Ukrainian, their fearlessness, their courage, their determination, inspires the world.

                        Groups of citizens blocking tanks with their bodies. Everyone from students to retirees teachers turned soldiers defending their homeland.

                        In this struggle as President Zelenskyy said in his speech to the European Parliament “Light will win over darkness.” The Ukrainian Ambassador to the United States is here tonight.

                        Let each of us here tonight in this Chamber send an unmistakable signal to Ukraine and to the world.

                        Please rise if you are able and show that, Yes, we the United States of America stand with the Ukrainian people.

                        Throughout our history we’ve learned this lesson when dictators do not pay a price for their aggression they cause more chaos.

                        They keep moving.

                        And the costs and the threats to America and the world keep rising.

                        That’s why the NATO Alliance was created to secure peace and stability in Europe after World War 2.

                        The United States is a member along with 29 other nations.

                        It matters. American diplomacy matters. American resolve matters.

                        Putin’s latest attack on Ukraine was premeditated and unprovoked.

                        He rejected repeated efforts at diplomacy.

                        He thought the West and NATO wouldn’t respond. And he thought he could divide us at home. Putin was wrong. We were ready.  Here is what we did.

                        We prepared extensively and carefully.

                        We spent months building a coalition of other freedom-loving nations from Europe and the Americas to Asia and Africa to confront Putin.

                        I spent countless hours unifying our European allies. We shared with the world in advance what we knew Putin was planning and precisely how he would try to falsely justify his aggression.

                        We countered Russia’s lies with truth.

                        And now that he has acted the free world is holding him accountable.

                        Along with twenty-seven members of the European Union including France, Germany, Italy, as well as countries like the United Kingdom, Canada, Japan, Korea, Australia, New Zealand, and many others, even Switzerland.

                        We are inflicting pain on Russia and supporting the people of Ukraine. Putin is now isolated from the world more than ever.

                        Together with our allies –we are right now enforcing powerful economic sanctions.

                        We are cutting off Russia’s largest banks from the international financial system.

                        Preventing Russia’s central bank from defending the Russian Ruble making Putin’s $630 Billion “war fund” worthless.

                        We are choking off Russia’s access to technology that will sap its economic strength and weaken its military for years to come.

                        Tonight I say to the Russian oligarchs and corrupt leaders who have bilked billions of dollars off this violent regime no more.

                        The U.S. Department of Justice is assembling a dedicated task force to go after the crimes of Russian oligarchs.

                        We are joining with our European allies to find and seize your yachts your luxury apartments your private jets. We are coming for your ill-begotten gains.

                        And tonight I am announcing that we will join our allies in closing off American air space to all Russian flights – further isolating Russia – and adding an additional squeeze –on their economy. The Ruble has lost 30% of its value.

                        The Russian stock market has lost 40% of its value and trading remains suspended. Russia’s economy is reeling and Putin alone is to blame.

                        Together with our allies we are providing support to the Ukrainians in their fight for freedom. Military assistance. Economic assistance. Humanitarian assistance.

                        We are giving more than $1 Billion in direct assistance to Ukraine.

                        And we will continue to aid the Ukrainian people as they defend their country and to help ease their suffering.

                        Let me be clear, our forces are not engaged and will not engage in conflict with Russian forces in Ukraine.

                        Our forces are not going to Europe to fight in Ukraine, but to defend our NATO Allies – in the event that Putin decides to keep moving west.

                        For that purpose we’ve mobilized American ground forces, air squadrons, and ship deployments to protect NATO countries including Poland, Romania, Latvia, Lithuania, and Estonia.

                        As I have made crystal clear the United States and our Allies will defend every inch of territory of NATO countries with the full force of our collective power.

                        And we remain clear-eyed. The Ukrainians are fighting back with pure courage. But the next few days weeks, months, will be hard on them.

                        Putin has unleashed violence and chaos.  But while he may make gains on the battlefield – he will pay a continuing high price over the long run.

                        And a proud Ukrainian people, who have known 30 years  of independence, have repeatedly shown that they will not tolerate anyone who tries to take their country backwards.

                        To all Americans, I will be honest with you, as I’ve always promised. A Russian dictator, invading a foreign country, has costs around the world.

                        And I’m taking robust action to make sure the pain of our sanctions  is targeted at Russia’s economy. And I will use every tool at our disposal to protect American businesses and consumers.

                        Tonight, I can announce that the United States has worked with 30 other countries to release 60 Million barrels of oil from reserves around the world.

                        America will lead that effort, releasing 30 Million barrels from our own Strategic Petroleum Reserve. And we stand ready to do more if necessary, unified with our allies.

                        These steps will help blunt gas prices here at home. And I know the news about what’s happening can seem alarming.

                        But I want you to know that we are going to be okay.

                        When the history of this era is written Putin’s war on Ukraine will have left Russia weaker and the rest of the world stronger.

                        While it shouldn’t have taken something so terrible for people around the world to see what’s at stake now everyone sees it clearly.

                        We see the unity among leaders of nations and a more unified Europe a more unified West. And we see unity among the people who are gathering in cities in large crowds around the world even in Russia to demonstrate their support for Ukraine.
                        """*/
    //if let url = Bundle.main.url(forResource: "FreudDreams", withExtension: "pdf") {
//        if let url = Bundle.main.url(forResource: "Jungtest", withExtension: "pdf") {
        //    let pdf = PDFLoader(fileURL: url)
    //Load the document and split into chunks (PDF OR TEXT????)
    /* func loadFile() -> [Document] {
     let fileURL = Bundle.main.url(forResource: "JungTest2", withExtension: "txt")
     let filePath = fileURL?.path ?? ""
     let textLoader = TextLoader(file_path: filePath)
     Task {
     do {
     let documents = try await textLoader._load()
     print(documents)
     return documents
     } catch {
     print("Failed to load text: \(error)")
     }
     }
     }*/
