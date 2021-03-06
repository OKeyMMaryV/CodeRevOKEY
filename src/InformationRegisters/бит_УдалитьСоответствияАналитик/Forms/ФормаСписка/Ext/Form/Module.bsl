
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаСпискаРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
		
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборВидаСоответствия(Список.Отбор, ВидСоответствия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСоответствияФильтрПриИзменении(Элемент)
	
	УстановитьОтборВидаСоответствия(Список.Отбор, ВидСоответствия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает отбор по виду соответствия.
// 
// Параметры:
//  Отбор           - Отбор.
//  ВидСоответствия - СправочникСсылка.бит_ВидыСоответствийАналитик.
// 
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВидаСоответствия(Отбор, ВидСоответствия)
	
	ЭО = Неопределено;
    
    Для каждого ТекЭО Из Отбор.Элементы Цикл
	
		Если ТекЭО.Представление = "ВидСоответствия" Тогда		
			ЭО = ТекЭО;		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Если ЗначениеЗаполнено(ВидСоответствия) Тогда
		
		Если ЭО = Неопределено Тогда			
			эо = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));			
        КонецЕсли; 
        
		эо.Использование    = Истина;
		эо.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ВидСоответствия");
		эо.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		эо.ПравоеЗначение   = ВидСоответствия;
		эо.Представление    = "ВидСоответствия";
		эо.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	Иначе	
		
		Если ЭО <> Неопределено Тогда			
			Отбор.Элементы.Удалить(ЭО);			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры // УстановитьОтборВидаСоответствия()

#КонецОбласти
