////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		бит_РаботаСДиалогамиКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ НА СЕРВЕРЕ

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	бит_РаботаСДиалогамиСервер.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, "Список", "Организация");

КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	бит_РаботаСДиалогамиСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры
