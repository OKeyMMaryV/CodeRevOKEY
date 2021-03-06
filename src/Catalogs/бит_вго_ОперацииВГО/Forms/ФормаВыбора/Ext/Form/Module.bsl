
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	бит_РаботаСДиалогамиСервер.ФормаВыбораПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	СписокНедоступныхВидовОпераций = Новый СписокЗначений;
	СписокНедоступныхВидовОпераций.Добавить(Перечисления.бит_вго_ВидыОперацийВГО.Остатки);
			
	ИсключаемыйТипОперации = Параметры.ИсключаемыйТипОперации;
	Если ЗначениеЗаполнено(ИсключаемыйТипОперации) Тогда
			
		НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		НовыйЭлементОтбора.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных("ТипОперации");
		НовыйЭлементОтбора.ВидСравнения    = ВидСравненияКомпоновкиДанных.НеРавно;
		НовыйЭлементОтбора.ПравоеЗначение  = ИсключаемыйТипОперации;
		НовыйЭлементОтбора.Использование   = Истина;	
		
		Если ИсключаемыйТипОперации = Перечисления.бит_вго_ТипыОперацийВГО.НачислениеЗадолженности Тогда
			СписокНедоступныхВидовОпераций.Добавить(Перечисления.бит_вго_ВидыОперацийВГО.Техническая);
		КонецЕсли;
				
	КонецЕсли;
	
	НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
	НовыйЭлементОтбора.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных("ВидОперации");
	НовыйЭлементОтбора.ВидСравнения    = ВидСравненияКомпоновкиДанных.НеВСписке;
	НовыйЭлементОтбора.ПравоеЗначение  = СписокНедоступныхВидовОпераций;
	НовыйЭлементОтбора.Использование   = Истина;
		
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

