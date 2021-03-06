
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Отчет);

	МетаданныеОбъекта = Метаданные.Отчеты.бит_ДвиженияДокумента;
		
	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Документ", Отчет.Документ);
	
    ПоказыватьДокумент = ?(Параметры.Свойство("ПоказыватьДокумент"), Параметры.ПоказыватьДокумент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// По умолчанию выводим в виде таблицы.
	ВыводДетализации 		   = "Вертикали";
	Отчет.ВыводитьВВидеТаблицы = Ложь;
	
	Если Не ОтчетСформирован Тогда

		СтрРегистрация = Новый Структура;
	    бит_ук_СлужебныйВызовСервера.РегистрацияНачалоСобытия(Ложь, СтрРегистрация, ЭтотОбъект.ИмяФормы);

		СформироватьИВывестиОтчет(СтрРегистрация);
		ОтчетСформирован = Истина;

	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыводДетализацииПриИзменении(Элемент)
	
	Если ВыводДетализации = "Вертикали" Тогда
		Отчет.ВыводитьВВидеТаблицы = Ложь;
	Иначе
		Отчет.ВыводитьВВидеТаблицы = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СформироватьВыполнить(Команда)
	
	СтрРегистрация = Новый Структура;
    бит_ук_СлужебныйВызовСервера.РегистрацияНачалоСобытия(Ложь, СтрРегистрация, ЭтотОбъект.ИмяФормы);
	
	Если НЕ ЗначениеЗаполнено(Отчет.Документ) Тогда		
		ПоказатьПредупреждение( , "Выберите документ, движения которого Вы хотите увидеть");     		
		Возврат;
	КонецЕсли;
	
	СформироватьИВывестиОтчет(СтрРегистрация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура осуществляет управление доступностью/видимостью элементов формы.
// 
&НаКлиенте
Процедура УправлениеЭлементамиФормы()
	
	Элементы.Документ.Видимость = ПоказыватьДокумент;
	
КонецПроцедуры // УправлениеЭлементамиФормы()

// Процедура вызывает процедуру объекта отчета по формированию.
// 
&НаСервере
Процедура СформироватьИВывестиОтчет(СтрРегистрация)
	                       
	РеквизитФормыВЗначение("Отчет").СформироватьОтчет(ТабличныйДокумент);
	
	бит_ук_СлужебныйСервер.РегистрацияФормированиеОтчета(Ложь, СтрРегистрация);
	
КонецПроцедуры

#КонецОбласти

