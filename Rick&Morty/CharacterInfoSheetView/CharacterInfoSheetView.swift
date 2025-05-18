//
//  CharacterInfoSheetView.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//  
//

import SwiftUI

struct CharacterInfoSheetView: View {
    
    private let animatingPortal = NSDataAsset(name: "AnimatingGifs/animating-portal-rick-and-morty")

    @State
    var viewModel = ViewModel() as ViewModelProtocol
    @State
    var characterImage: UIImage?
    @State
    private var animatingPortalImage: Image?
    // NOTE: When using CGAnimateImageDataWithBlock, we cannot stop the animation. But it replaces the animationPortlImage
    //       for every frame, triggering view updates, even if the image is not shown. A trick/workaround is to have a
    //       boolean animatingPortalPaused, which does not stop the actual animation, but does at least stop the animation
    //       from triggering unnecessary viewUpdates.
    @State
    private var animatingPortalPaused: Bool = false

    @FetchRequest
    private var fetchedCharacter: FetchedResults<Character>
    
    init(characterId: Int64) {
        let predicate = NSPredicate(format: "id == %d", characterId)
        self._fetchedCharacter = FetchRequest(sortDescriptors: [],
                                            predicate: predicate,
                                            animation: .default)
    }
    
    
    var body: some View {
        
#if DEBUG
        Self._printChanges()
#endif
        
        return ZStack {
            
            GeometryReader { geometry in
                ApplicationStyle.Images.rickAndMortyFabric
                    .blur(radius: 3)
                    .frame(maxWidth: geometry.size.width)
            }
            
            VStack {
                Spacer()
                    .frame(height: 16)
                
                VStack {
                    Text(fetchedCharacter.first?.name ?? ApplicationStyle.randomWotsItsName())
                        .font(ApplicationStyle.Fonts.hugeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(ApplicationStyle.Colors.green)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                        .shadow(color: ApplicationStyle.Colors.yellow, radius: 3, x: 0, y: 0)
                }
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                .shadow(color: Color.black, radius: 3, x: 0, y: 0)

                if ApplicationStyle.isRickSanchez(name: fetchedCharacter.first?.name) {
                    VStack {
                        Text(viewModel.funGuyText)
                            .font(ApplicationStyle.Fonts.text)
                            .fontWeight(.bold)
                            .foregroundStyle(ApplicationStyle.Colors.yellow)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.green, radius: 1, x: 0, y: 0)
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .shadow(color: Color.black, radius: 3, x: 0, y: 0)
                }
                
                Spacer()
                    .frame(height: 24)

                if fetchedCharacter.first == nil {
                    VStack {
                        Spacer()
                        Text(viewModel.noDataText)
                            .font(ApplicationStyle.Fonts.largeTitle)
                            .foregroundStyle(ApplicationStyle.Colors.green)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.yellow, radius: 3, x: 0, y: 0)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .shadow(color: Color.black, radius: 3, x: 0, y: 0)
                }
                else {
                    
                    ScrollView(.vertical) {
                        
                        ZStack {
                            // NOTE: We cannot use AsyncImage here, as we want to reuse the downloaded image for the PDF.
                            //       if we use AsyncImage here, we will have to use AsyncImage in the render() function
                            //       of the PDF as well, and then we get into tricky async stuff. Easire is to use the
                            //       view to asynchronously download the image, cache it, and then just reuse the already
                            //       cached image for the PDF.
                            if let characterImage {
                                Image(uiImage: characterImage)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 32, trailing: 8))
                                    .onAppear {
                                        animatingPortalPaused = true
                                    }
                            }
                            else {
                                animatingPortalImage
                                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 32, trailing: 8))
                                    .onAppear {
                                        Task {
                                            if let imageUrlString = fetchedCharacter.first?.imageUrl,
                                               let imageUrl = URL(string: imageUrlString) {
                                                characterImage = await CachedImageStorage.downloadImage(url: imageUrl)
                                            }
                                        }
                                    }
                            }
                            
                            ApplicationStyle.Images.photoFrame
                                .resizable()
                                .scaledToFit()
                                .shadow(color: Color.black, radius: 8, x: 0, y: 0)
                        }

                        Text(viewModel.characterInfoString(character: fetchedCharacter.first!, fallback: viewModel.somethingWrongText))
                            .font(ApplicationStyle.Fonts.largeTitle)
                            .foregroundStyle(ApplicationStyle.Colors.green)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.yellow, radius: 2, x: 0, y: 0)

                        HStack {
                        
                            ShareLink(item: viewModel.renderPDFForExport(character: fetchedCharacter.first, characterImage: characterImage)) {
                                Text(viewModel.shareAsPDFText)
                                    .font(ApplicationStyle.Fonts.title)
                                    .foregroundStyle(ApplicationStyle.Colors.pink)
                                    .multilineTextAlignment(.center)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                                    .shadow(color: ApplicationStyle.Colors.skin, radius: 2, x: 0, y: 0)
                            }
                            .shadow(color: Color.black, radius: 3, x: 0, y: 0)

                            ShareLink(item: viewModel.renderCSVForExport(character: fetchedCharacter.first)) {
                                Text(viewModel.shareAsCSVText)
                                    .font(ApplicationStyle.Fonts.title)
                                    .foregroundStyle(ApplicationStyle.Colors.pink)
                                    .multilineTextAlignment(.center)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                                    .shadow(color: ApplicationStyle.Colors.skin, radius: 2, x: 0, y: 0)
                            }
                            .shadow(color: Color.black, radius: 3, x: 0, y: 0)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .scrollIndicators(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            .containerBackground(Color.white.opacity(0), for: .navigation)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .toolbarVisibility(.visible, for: .automatic)
        }
        .onAppear {
            if let animatingPortal {
                let gifData = animatingPortal.data as CFData
                CGAnimateImageDataWithBlock(gifData, nil) { index, cgImage, stop in
                    if !animatingPortalPaused {
                        self.animatingPortalImage = Image(uiImage: .init(cgImage: cgImage))
                    }
                }
            }
        }
    }
}

#Preview {
    CharacterInfoSheetView(characterId: 1)
}

