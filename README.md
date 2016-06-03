# iOS VR Boilerplate 

Это готовый проект позволяющий быстро начать использовать Apple SceneKit и Google VR SDK, для того чтобы создавать интерактивные виртуальные приложения для iOS.   

## CocoaPods 

Проект использует CocoaPods. В этом zip файле необходимая зависимость уже установлена. Для работы с проектом необходимо открыть **VRBoilerplate.xcworkspace**

## SceneKit 

SceneKit — это высокоуровневый фреймворк для 3D графики то Apple.

Он похож на UIKit, только вместо UIView в качестве основного блока используется SCNNode. 

```swift
// создаем пустую сцену
scene = [SCNScene scene];

// создаем Node, в ней будет лежать параллипипед 1x1x1 (куб) со скругленными углами
SCNNode *boxNode = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0.2]];

// перемещаем его
boxNode.position = SCNVector3Make(0, 0, -3);

// и поворачиваем
boxNode.eulerAngles = SCNVector3Make(M_PI_4, M_PI_4, 0);

// создаем материал
SCNMaterial *m = [SCNMaterial material];

// с нужными нам цветом
m.diffuse.contents = [UIColor cyanColor];

// устанавливаем созданный метариал для нашей Node
boxNode.geometry.materials = @[m];

// добавляем в сцену
[scene.rootNode addChildNode:boxNode];

// чтобы удалить node из сцены, можно вызвать [boxNode removeFromParentNode];
```

Как и с UIKit можно сохранить указатель на Node и потом его менять, чтобы реализовать интерактивное поведение. Так же сцены можно создавать используя редактор сцен в Xcode — это 3D аналог интерфейс-билдера. Нужный node можно потом найти по имени.   

В обычной жизни создается SCNView (которая является UIView) и устанавливается свойство scene для нее. 

Данный проект использует пассивную модель — сцену нужно создать в классе соответствующем VRControllerProtocol.  


## VRControllerProtocol 

Рассмотрим VRControllerProtocol. Не считая конструктора init он определяет 3 простых метода.

### - scene 

Read-only свойство, которое возвращает SCNScene. Не может вернуть null, сам экземпляр сцены не должен меняться в течении жизни объекта.

### - prepareFrameWithHeadTransform:

Вызывается перед каждым кадром (один раз на оба глаза). В параметре передается поворот головы от Google VR SDK. 

### - eventTriggered

Вызывается при "щелчке" магнитиком на Cardboard или одиночном клике на окне симулятора. 


### Указание класса  

Специальный ключ `VRControllerClass` в файле Info.plist указывает имя класса объекта, который будет создан при старте приложения. 

При использовании Swift, необходимо указать objc имя класса: 

```swift 
@objc(VRControllerSwift)
class VRControllerSwift : NSObject, VRControllerProtocol {
// ...
```


## Особенности  

- Зритель находится в точке (0, 0, 0) и смотрит по сторонам.  Код не рассчитывает на наличие SCNCamera в сцене или их перемещение. При старте зритель смотрит в направлении 0, 0, -1. То направлении в котором вы держали Cardboard в реальном мире на старте приложения и станет 0,0,-1 в VR. 

- Интеграция GVR и SceneKit порождает некоторое количество проблем, например 

    - отражающий(.reflectivity > 0) пол (SCNFloor) не работает 
    
    - не удается использовать SpriteKit сцены в качестве материалов 

    - Performance, performance, performance: VR режим в целом более требователен к производительности. В некоторых случаях, симулятор может работать медленней реального устройства

    - два warnings при компиляции: … direct access in gvr::Singleton<gvr::ServerLogger>::GetInstance() to global weak symbol — заведен [issue](https://github.com/googlevr/gvr-ios-sdk/issues/22) в проекте GVR

- В SceneKitVRRenderer есть следующие особенности (которые можно изменить) 

    - scene.renderAtTime(0) всегда вызывается с 0. В этом аргументе передается время сцены, которое по умолчанию выключено. Обычно сцены используют системное время, поэтому это не имеет значения. 

    - включен autoenablesDefaultLighting у Renderer 


## Ресурсы

### SkyBox (intersteallar-stars.png)

Interstellar 
http://opengameart.org/content/interstellar-skybox
By Jockum Skoglund aka hipshot
hipshot@zfight.com
www.zfight.com
Stockholm, 2005 08 25


### Space Invader Model 

Submitted by:
nicola3dmodels
Non-commercial use License

http://tf3dm.com/3d-model/space-invader-26504.html
http://tf3dm.com/3d-model/space-invader-42443.html
http://tf3dm.com/3d-model/space-invader-84114.html


