
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ФормаОплаты", ОтборФормаОплаты);
		
	Если ЗначениеЗаполнено(ОтборФормаОплаты) Тогда
		ПриИзмененииФормыОплатыНаСервере();
	Иначе
		Элементы.ОтборФормаОплаты.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииФормыОплатыНаСервере()

	Модуль = Перечисления.бит_ВидыОперацийЗаявкаНаРасходование;
	ДоступныеЗначения = Модуль.ПолучитьДоступныеЗначения(Новый Структура("ФормаОплаты", ОтборФормаОплаты)).ДоступныеЗначения;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", ДоступныеЗначения, 
         ВидСравненияКомпоновкиДанных.ВСписке,, ЗначениеЗаполнено(ОтборФормаОплаты));
		 
КонецПроцедуры
 
#КонецОбласти