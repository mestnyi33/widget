; Декларация
; class NSAffineTransform : NSObject
; Создание аффинного преобразования
; init(tr ansform: AffineTransform)
; Инициализирует матрицу получателя с помощью другого объекта преобразования.
MyTransform = CocoaMessage(0, 0, "NSAffineTransform transform"); get an identity transform

sx.CGFloat = 5.5
sy.CGFloat = 20
; Накопление преобразований
; func scaleX(by: CGFloat, yBy: CGFloat)
; Применяет коэффициенты масштабирования к каждой оси матрицы преобразования приемника.
CocoaMessage(0, MyTransForm, "scaleXBy:@", @sx, "yBy:@", @sy); scale x by 5.5, y by 20

; struct NSAffineTransformStruct
; Структура, которая определяет матрицу размером три на три, которая выполняет аффинное преобразование между двумя системами координат.
MyTransformStruct.NSAffineTransform

; var transformStruct: NSAffineTransformStruct
; Коэффициенты матрицы сохраняются как матрица преобразования.
CocoaMessage(@MyTransformStruct, MyTransForm, "transformStruct"); get the transform structure

Debug MyTransformStruct\m11; debug outputs 5.5


CocoaMessage(0, MyTransForm, "HIViewSetVisible:@", @view);, "true:@",1); scale x by 5.5, y by 20
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; EnableXP