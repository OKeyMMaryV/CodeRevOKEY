#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
			
// Функция формирует кэш цветов для конвертации WEB цветов и цветов из стилей. 
// Необходимо, т.к. платформа для web-цветов и цветов стилей не возвращает RGB...
// 
// Параметры:
//  ИмяМакета  - Строка
// 
// Возвращаемое значение:
//   Цвета   - Соответствие
// 
Функция ПолучитьКэшЦветов(ИмяМакета)  Экспорт

	Цвета = Новый Соответствие;
	
	Макет = Обработки.бит_ПреобразованияЦветов.ПолучитьМакет(ИмяМакета);
	
	// Получим данные из макета
	НСтрока      = 2;
	НКолонкаТест = 1;
	ТестовоеЗначение = СокрЛП(Макет.Область(НСтрока,НКолонкаТест,НСтрока,НКолонкаТест).Текст);
	Дальше = ЗначениеЗаполнено(ТестовоеЗначение);

	Пока Дальше Цикл
		
		ИмяЦвета     = СокрЛП(Макет.Область(НСтрока,1,НСтрока,1).Текст);
		Цвет16       = СокрЛП(Макет.Область(НСтрока,3,НСтрока,3).Текст);
		
		Если ИмяМакета = "WebЦвета" Тогда
			
			Попытка
				
				ТекЦвет = WebЦвета[ИмяЦвета];
				Цвета.Вставить(ТекЦвет,Цвет16);
				
			Исключение
				// Сообщить(ИмяЦвета);
			КонецПопытки; 
			
			
		ИначеЕсли ИмяМакета = "ЦветаСтиля" Тогда
			
			Попытка
				
				ТекЦвет = ЦветаСтиля[ИмяЦвета];
				Цвета.Вставить(ТекЦвет,Цвет16);
				
			Исключение
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ИмяЦвета);
			КонецПопытки; 
			
			
		КонецЕсли; 
		
        НСтрока = НСтрока + 1;				
        ТестовоеЗначение = СокрЛП(Макет.Область(НСтрока,НКолонкаТест,НСтрока,НКолонкаТест).Текст);
        Дальше = ЗначениеЗаполнено(ТестовоеЗначение);
		
	КонецЦикла;  // По строкам макета


	Возврат Цвета;
	
КонецФункции // ПолучитьКэшВебЦветов()

// Функция преобразует цвет в Hex из WebЦветов и RGB. 
// Используется для преобразования выбранных цветов в поле выбора.
// 
// Параметры:
//  ТекущийЦвет  - Цвет.
//  ВебЦвета     - Соответствие, кэш веб-цветов.
//  ЦветаСтиля   - Соответствие, кэш цветов стиля.
// 
Функция ПрообразоватьЦвет(ТекущийЦвет,ВебЦвета = Неопределено,ЦветаСтиля = Неопределено)  Экспорт

	ЦветШестн   = "";
	
	Если НЕ ТекущийЦвет = Неопределено Тогда
		
		Если ТекущийЦвет.Вид = ВидЦвета.WebЦвет Тогда
			
			Если ВебЦвета = Неопределено Тогда
				
				ВебЦвета = ПолучитьКэшЦветов("WebЦвета");
				
			КонецЕсли; 
			
			ЦветШестн = ВебЦвета[ТекущийЦвет];
			
			
		ИначеЕсли ТекущийЦвет.Вид = ВидЦвета.WindowsЦвет Тогда
			
			// Windows цвета в диалоге выбора цвета 1С выбрать нельзя.
			
		ИначеЕсли ТекущийЦвет.Вид = ВидЦвета.ЭлементСтиля Тогда
			
			Если ЦветаСтиля = Неопределено Тогда
				
				ЦветаСтиля = ПолучитьКэшЦветов("ЦветаСтиля");
				
			КонецЕсли; 
			
			ЦветШестн = ЦветаСтиля[ТекущийЦвет];
			
		Иначе	
			
			ЦветШестн = ColorToHEX(ТекущийЦвет.Красный,ТекущийЦвет.Зеленый,ТекущийЦвет.Синий);
			
		КонецЕсли; 
		
				
	КонецЕсли; 

	Возврат ЦветШестн;
	
КонецФункции // ИзменениеЦвета()

// Функция преобразует цвет из RGB/ARGB представления в HEX.
// 
// Параметры:
// R - Число(0-255).
// G - Число(0-255).
// B - Число(0-255).
// A - Число(0-255).
// ColorFormat - Строка - "RGB","ARGB".
// 
// Возвращаемое значение:
//  stringHex - Строка.
// 
Function ColorToHEX(Red,Green,Blue,Alpha=255,ColorFormat = "RGB") Экспорт
	
	stringHex = "#";
	
	IF ColorFormat = "ARGB" Then
		
		stringHex = stringHex+DecToHex(Alpha,2);
		
	EndIf;

	stringHex = stringHex+DecToHex(Red,2);
	stringHex = stringHex+DecToHex(Green,2);
	stringHex = stringHex+DecToHex(Blue,2);
	
	stringHex = Upper(stringHex);
	
	return stringHex;
	
EndFunction	

// Функция преобразует цвет из Hex представления в RGB.
// 
// Параметры:
//  HexColor - Строка
//  ColorFormat - Строка
// 
// Возвращаемое значение:
//  col - Цвет
// 
Function HexToColor(HexColor,ColorFormat = "RGB") Export
	
	hexString = StrReplace(HexColor,"#","");
	
	tempString = Сред(hexString,1,2);
	Red = HexToDec(tempString);
	
	tempString = Сред(hexString,3,2);
	Green = HexToDec(tempString);
	
	tempString = Сред(hexString,5,2);
	Blue = HexToDec(tempString);
	
	col = new Color(Red,Green,Blue);
	
	return col;
	
EndFunction	

// Функция преобразует десятичное число в шестнадцатеричное.
// 
// Параметры:
//  DecNumber - Число
//  Digits - ЧислоРазрядов
// 
// Возвращаемое значение:
//  stringHex - Строка
// 
Function DecToHex(DecNumber,Digits) Export
	
	stringHex = "";
	arrHex    = new Array;
	arrHex.Add("0");
	arrHex.Add("1");
	arrHex.Add("2");
	arrHex.Add("3");
	arrHex.Add("4");
	arrHex.Add("5");
	arrHex.Add("6");
	arrHex.Add("7");
	arrHex.Add("8");
	arrHex.Add("9");
	arrHex.Add("A");
	arrHex.Add("B");
	arrHex.Add("C");
	arrHex.Add("D");
	arrHex.Add("E");	
	arrHex.Add("F");
	
	If DecNumber = 0 Then
		stringHex = stringHex+"0";
	Else
		ind = 0;
		tempNumber = DecNumber;
			rem = tempNumber%16;
			If rem = 0 Then
				newStr     = DecToHex(Int(tempNumber/16),0);
				stringHex  = newStr+"0"+stringHex;			
			    tempNumber = 0;			
			Else
				stringHex = arrHex[rem]+stringHex;			
				tempNumber = tempNumber-rem*Pow(16,ind);	
				If tempNumber > 0 Then
					newStr     = DecToHex(Int(tempNumber/16),0);
					stringHex  = newStr+stringHex;			
				EndIf
			EndIf;
	EndIf;
	
	Delta = Digits-StrLen(stringHex);	
	If Delta>0 Then
		For ind = 1 to Delta Do
			stringHex = "0"+stringHex;
		EndDo;
	EndIf;	
	
 return stringHex;
 
EndFunction

// Функция преобразует шестнадцатеричное число в десятичное.
// 
// Параметры:
//  HexString - Строка
// 
// Возвращаемое значение:
//  decNum - Строка
// 
Function HexToDec(HexString)  Export
	
	decNum = 0;	
	
	HexVal = new Map;
	HexVal.Insert("0",0);
	HexVal.Insert("1",1);
	HexVal.Insert("2",2);
	HexVal.Insert("3",3);
	HexVal.Insert("4",4);
	HexVal.Insert("5",5);
	HexVal.Insert("6",6);
	HexVal.Insert("7",7);
	HexVal.Insert("8",8);
	HexVal.Insert("9",9);
	HexVal.Insert("A",10);
	HexVal.Insert("B",11);
	HexVal.Insert("C",12);
	HexVal.Insert("D",13);
	HexVal.Insert("E",14);
	HexVal.Insert("F",15);

	
	tempString = StrReplace(HexString,"#","");
	
	length = StrLen(tempString);
	
	For i = 1 to length DO
		
		symbol = Mid(tempString,length+1-i,1);
		decVal = HexVal[symbol];
		if decVal=Undefined Then
			decVal = 0;
		EndIf;
		
		factor = Pow(16,i-1);
		
		decNum  = decNum+factor*decVal;
		
	EndDo;
	
	return decNum;
	
EndFunction	

#КонецОбласти
 
#КонецЕсли
