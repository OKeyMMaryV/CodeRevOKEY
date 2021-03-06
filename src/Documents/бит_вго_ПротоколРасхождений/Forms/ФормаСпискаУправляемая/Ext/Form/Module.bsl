
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

  	// Стандартные действия при создании на сервере.
 	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьВидимостьТаблицыПроводок(Не фСкрытьТаблицуПроводок); 	
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура КомандаТаблицаПроводок(Команда)
	
	фСкрытьТаблицуПроводок = Не фСкрытьТаблицуПроводок;
	
	УстановитьВидимостьТаблицыПроводок(Не фСкрытьТаблицуПроводок);
		
КонецПроцедуры // КомандаТаблицаПроводок()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость таблицы проводок.
// 
// Параметры:
//  ВидимостьТаблицы  - Булево
// 
&НаСервере
Процедура УстановитьВидимостьТаблицыПроводок(ВидимостьТаблицы)

	Элементы.ФормаКомандаТаблицаПроводок.Пометка = ВидимостьТаблицы;
	Элементы.Проводки.Видимость 				 = ВидимостьТаблицы;
	Элементы.Стабилизатор.Видимость 			 = Не ВидимостьТаблицы;	

КонецПроцедуры // УстановитьВидимостьТаблицыПроводок()

#КонецОбласти