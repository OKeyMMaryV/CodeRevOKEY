
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ТекущаяИнформационнаяБаза",Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиПодключения

&НаКлиенте
Процедура НастройкиПодключенийНастройкаПодключенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.НастройкиПодключений.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ВидИнформационнойБазы) 
		 И НЕ ТекущаяСтрока.ВидИнформационнойБазы = фКэшЗначений.ТекущаяИнформационнаяБаза Тогда
		
		МассивПараметров = Новый Массив;
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидИнформационнойБазы", ТекущаяСтрока.ВидИнформационнойБазы);
		МассивПараметров.Добавить(НовыйПараметр);
		
		Элементы.НастройкиПодключенийНастройкаПодключения.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПодключенийНастройкаПодключенияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.НастройкиПодключений.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.НастройкаПодключения) 
		 И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВидИнформационнойБазы) Тогда
		 
		 ЗаполнитьВидБазы(ТекущаяСтрока.ПолучитьИдентификатор());
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПодключенийВидИнформационнойБазыПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.НастройкиПодключений.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ВидИнформационнойБазы) 
		И НЕ ТекущаяСтрока.ВидИнформационнойБазы = фКэшЗначений.ТекущаяИнформационнаяБаза Тогда
	
		ТекущаяСтрока.НастройкаПодключения = Неопределено;
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет вид базы из данных настройки подключения.
// 
// Параметры:
//  ИдСтроки - Число
// 
&НаСервере
Процедура ЗаполнитьВидБазы(ИдСтроки)

	ТекущаяСтрока =  Объект.НастройкиПодключений.НайтиПоИдентификатору(ИдСтроки);
	
	Если НЕ ТекущаяСтрока = Неопределено  Тогда
	
		 ТекущаяСтрока.ВидИнформационнойБазы = ТекущаяСтрока.НастройкаПодключения.ВидИнформационнойБазы;
	
	КонецЕсли; 

КонецПроцедуры // ЗаполнитьВидБазы()

#КонецОбласти

