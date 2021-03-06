
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если ЗначениеЗаполнено(Объект.Билет) Тогда
		НДСНеВыделять = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Билет, "НДСНеВыделять");
	КонецЕсли;	
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСостояниеДокумента();
	КонецЕсли; 
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// Пессимистическая блокировка данных операции на случай, если редактируется билет или другая операция по тому же билету
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Объект.Билет,, УникальныйИдентификатор);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось заблокировать данные билета: %1'")+"
		|%2";
		ТекстСообщения = СтрШаблон(ТекстСообщения, Объект.Билет, ОписаниеОшибки());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Билет);
		ТолькоПросмотр = Истина;
	КонецПопытки;	
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	УстановитьСостояниеДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БилетПриИзменении(Элемент)
	
	БилетПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	РассчитатьСуммыНДС(Объект, Элемент.Имя, НДСНеВыделять);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	РассчитатьСуммыНДС(Объект, Элемент.Имя, НДСНеВыделять);
КонецПроцедуры

&НаКлиенте
Процедура СуммаНДСПриИзменении(Элемент)
	ОбработатьИзменениеСуммыНДС(Объект);
КонецПроцедуры

&НаКлиенте
Процедура СуммаНеОблагаемаяНДСПриИзменении(Элемент)
	РассчитатьСуммыНДС(Объект, Элемент.Имя, НДСНеВыделять);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	ЗаголовокБилетЗамена = НСтр("ru='Новый билет'");
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСБилетами.ЗаменаПокупка") Тогда
		ЗаголовокБилетЗамена = НСтр("ru='Прежний билет'");
	КонецЕсли;	
	Элементы.БилетЗамена.Заголовок = ЗаголовокБилетЗамена;
	
	Элементы.БилетЗамена.Видимость = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСБилетами.ЗаменаПокупка")
										ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСБилетами.ЗаменаВозврат"));
		
	Элементы.Штраф.Видимость = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСБилетами.Возврат"));
	
	// СКРЫТЬ НДС ПРИ ПРИМЕНЕНИИ УСН ДОХОДЫ
	ВидимостьНДС = НЕ Форма.НДСНеВыделять;
	
	Элементы.СуммаНеОблагаемаяНДС.Видимость	= ВидимостьНДС;
	Элементы.СтавкаНДС.Видимость			= ВидимостьНДС;
	Элементы.СуммаНДС.Видимость				= ВидимостьНДС;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеОбработчикиСобытий

&НаСервере
Процедура БилетПриИзмененииНаСервере()

	Если ЗначениеЗаполнено(Объект.Билет) Тогда
		НДСНеВыделять = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Билет, "НДСНеВыделять");
	КонецЕсли;	

	УправлениеФормой(ЭтотОбъект);	
	
    // Счета учета расчетов будут заполнены при записи
	Объект.СчетУчетаРасчетовСКонтрагентом = Неопределено;
	Объект.СчетУчетаРасчетовПоАвансам = Неопределено;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммыНДС(ДанныеФормы, ИмяЭлемента, НДСНеВыделять)
	
	Если НДСНеВыделять Тогда
		Возврат;
	КонецЕсли;	
	
	ОблагаемаяСумма = ДанныеФормы.Сумма - ДанныеФормы.СуммаНеОблагаемаяНДС;
	
	Если ОблагаемаяСумма = 0 Тогда
		ДанныеФормы.СуммаНДС = 0;
		Возврат;
	КонецЕсли;	
	
	Если ОблагаемаяСумма < 0 Тогда
		
		Если Найти(ИмяЭлемента, "СуммаНеОблагаемаяНДС") = 0 Тогда
			ДанныеФормы.СуммаНеОблагаемаяНДС = ДанныеФормы.Сумма;
		Иначе
			ДанныеФормы.Сумма = ДанныеФормы.СуммаНеОблагаемаяНДС;
		КонецЕсли;
		
		ДанныеФормы.СуммаНДС = 0;
		Возврат;
		
	КонецЕсли;	
		
	ДанныеФормы.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		ОблагаемаяСумма,
		Истина,
		УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ДанныеФормы.СтавкаНДС, Ложь));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзменениеСуммыНДС(ДанныеФормы)
	
	Если ДанныеФормы.СуммаНДС > ДанныеФормы.Сумма Тогда
		ДанныеФормы.Сумма = ДанныеФормы.СуммаНДС; 	
		ДанныеФормы.СуммаНеОблагаемаяНДС = 0; 	
		Возврат;
	КонецЕсли;	
	
	СтавкаНДСВПроцентах = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ДанныеФормы.СтавкаНДС, Ложь);
	
	Если СтавкаНДСВПроцентах = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ОблагаемаяСумма = ДанныеФормы.СуммаНДС / СтавкаНДСВПроцентах * 100;
	
	ДанныеФормы.СуммаНеОблагаемаяНДС = ДанныеФормы.Сумма - ОблагаемаяСумма - ДанныеФормы.СуммаНДС; 	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
