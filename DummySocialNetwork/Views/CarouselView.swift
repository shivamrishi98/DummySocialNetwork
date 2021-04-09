//
//  CarouselView.swift
//  CarouselScrollView
//
//  Created by Shivam Rishi on 08/04/21.
//

import UIKit

struct CarouselViewModel {
    let imageName:String
    let title:String
}

final class CarouselView: UIView {

    private let viewModels:[CarouselViewModel]
    
    
     init(frame: CGRect, viewModels:[CarouselViewModel]) {
        self.viewModels = viewModels
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(pageControl)
        pageControl.numberOfPages = viewModels.count
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    private let pageControl:UIPageControl = {
        let control = UIPageControl(frame: .zero)
        control.currentPage = 0
        control.tintColor = .orange
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .label
        return control
    }()
    
    override func layoutSubviews() {
         
        scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: frame.size.width,
                                  height: frame.size.height)
        
        configureScrollView()
        
    }
    
    func configureScrollView() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollView.contentSize = CGSize(width: strongSelf.scrollView.frame.size.width*CGFloat(strongSelf.viewModels.count),
                                                       height: strongSelf.scrollView.frame.size.height)
            
            for index in 0..<strongSelf.viewModels.count {
                let viewModel = self?.viewModels[index]
                let imageView = UIImageView(image: UIImage(named: viewModel?.imageName ?? ""))
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 10 + strongSelf.scrollView.frame.size.width*CGFloat(index),
                                         y: 20,
                                         width: strongSelf.scrollView.frame.size.width-20,
                                         height: strongSelf.scrollView.frame.size.height-80)
                let label = UILabel()
                label.text = viewModel?.title
                label.textColor = .label
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 24, weight: .semibold)
                label.frame = CGRect(x: 10 + strongSelf.scrollView.frame.size.width*CGFloat(index),
                                     y: imageView.bottom + 10,
                                     width: strongSelf.scrollView.frame.size.width-20,
                                     height: strongSelf.scrollView.frame.size.height-imageView.height-50)
                strongSelf.scrollView.addSubview(imageView)
                strongSelf.scrollView.addSubview(label)
            }
            
            strongSelf.pageControl.frame = CGRect(
                x: 0,
                y: (strongSelf.scrollView.frame.size.height+strongSelf.scrollView.frame.origin.y) - 20,
                width: strongSelf.scrollView.frame.size.width,
                height: 20)
        }
    }
    
}

extension CarouselView:UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(value)
    }

}
