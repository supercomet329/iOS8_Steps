//
// Copyright 2014 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import CoreImage

class ChromaKeyFilter: CIFilter {
  // MARK: - Properties
  var kernel: CIColorKernel?
  var inputImage: CIImage?
  var activeColor: CIColor?
  
  // MARK: - Initialization
  override init() {
    super.init()
    kernel = createKernel()
  }
  
  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    kernel = createKernel()
  }
  
  // MARK: - API
  func outputImage() -> CIImage? {
    if let inputImage = inputImage {
      let dod = inputImage.extent()
      if let kernel = kernel {
        var args = [inputImage as AnyObject]
        return kernel.applyWithExtent(dod, arguments: args)
      }
    }
    return nil
  }
  
  // MARK: - Utility methods
  private func createKernel() -> CIColorKernel {
    let kernelString =
    "kernel vec4 passThrough( __sample s) { " +
      "  return s.rgba; " +
    "}"
    return CIColorKernel(string: kernelString)
  }
}
