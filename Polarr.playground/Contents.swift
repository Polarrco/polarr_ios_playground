/*:
 # UIKit GPU Simulation
 ## An iOS Interview playground.
 
#### Description:
 This is a view based playground where you can preview in the assisted editor on the right.
 The `GridViewController` uses a scrollview and is capable of dispalying an infinit grid of reusable cells.
 
  For the purpose of this experiment, it's wired up so that when a grid cell needs to show or update, a kernel function will get called, resulting in how that cell is configured. You can think of it as a simulation of Fragment shaders or kernel functions in the GPU where in terms of image processing you are often operating on a per pixel basis in parallel.
 
 You shouldn't need too, but feel free to alter any source files you need to.
 
*/

import UIKit
import PlaygroundSupport
import simd
// Sources & Utilities Included
/*:
 ### Personalization:
 This section allows you to subclass the main view controller for whatever reason.
 */
class MyViewController: GridViewController {}

/*:
 ### Setup and Display:
 This section just dispalys the playground preview. You shouldn't need to alter.
 */

// Present the view controller in the Live View window
let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 700, height: 700)
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.liveView
viewController.gridKernel = .custom

/*:
 ### Option 1, Easy.:
 Given the example `Kernel`'s below, create a kernel that draws a circle with a variable radius color and border.
 Part 2. Create another kernel drawing another shape. Bonus if it's an N-sided polygon.
 */

let randomKernel: Kernel = { item, output in
    output.color = UIColor(
        hue: CGFloat.random(in: 0.0...1.0),
        saturation: CGFloat.random(in: 0.0...0.4),
        brightness: CGFloat.random(in: 0.25...0.7),
        alpha: 1.0)
}
//
let checkerboardKernel: Kernel = { item, output in
    switch item.row % 2 {
    case 0:
        switch item.column % 2 {
        case 0:
            output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default:
            output.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    default:
        switch item.column % 2 {
        case 0:
            output.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default:
            output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    output.border = (.gray, 1.0)
}

viewController.customKernel = checkerboardKernel

/*:
 ### Option 2. Medium:
 Load and display a filtered image. The filter can be anything such as contrast or brightness.
 You are supplied a mechanism to get an image bundled with the playground and a way to get pixels from it.
 */

//let image = UIImage(named: "Clement.png")
let image = UIImage(named: "yinyang.png")!.cgImage!
let pixelData = image.pixelData()

// kernel
let filterKernel: Kernel = { item, output in
    output.color = .black
    output.border = (.gray, 1.0)
}

// viewController.customKernel = filterKernel


/*:
 ### Option 3, Hard.:
 Use the grid display, local storage, and a timing mechanism to illustrate a chosen algorythm over time.
 For instance, Color Fill, A*, Sorting algorythms...
 
 Please reference the **Grid** protocol that the GridViewController conforms to.
 You could subclass the GrdiViewController, adding a timing mechanism and update only the cells that need to with the `processItem` function.
 
 
 
 */

/*:
 ### Option 4, WildCard.:
Use your creativity to show or display something interesting in the grid.
 
 */

/*:
 ### Option 5, User Interface:
 Create a user interface to switch kernels, illustrating UIKit compentency.
 
 */

/*:
 ### Option 6, Improvement and Interation:
 Find a meaningful way to improve this assignment and submit a PR to the repo or deliver privately via a zipped project folder. This could be an additional question. Bug fix. Some additional feature to the base project that will improve the experience for future candidates.
 
 */

//: ![The real head of the household?](yinyang.png)
