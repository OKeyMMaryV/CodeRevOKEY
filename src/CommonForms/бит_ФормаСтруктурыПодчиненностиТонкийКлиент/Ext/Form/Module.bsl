
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит дерево документов на сервере.
&НаСервере
Перем мДерево;

// Хранит соответствие документов и признак присутствия в списке на сервере.
&НаСервере
Перем мУжеВСписке;

// Хранит соответствие имени документов и их метаданных на сервере.
&НаСервере
Перем мКэшРеквизитовДокумента;

// Хранит соответствие документов и права доступа к ним на сервере.
&НаСервере
Перем мКэшПраваДоступаКМетаданным;


////////////////////////////////////////////////////////////////////////////////
// КЛИЕНТСКИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// бит_DKravchenko Процедура вызывает процедуру по заполнению дерева документов.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ВыполнитьОбновлениеДереваДокументов()
	
	ВывестиДеревоДокументов();
	РазвернутьТаблицуДокументов();
		
КонецПроцедуры

// бит_DKravchenko Процедура разворачивает дерево документов.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура РазвернутьТаблицуДокументов()

	ЭлементыДерева = ДеревоДокументов.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыДерева Цикл

		Элементы.ДеревоДокументов.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);

	КонецЦикла;

КонецПроцедуры

// бит_DKravchenko Процедура устанавливает индекс пиктограммы текущего состояния документа на клиенте.
//
// Параметры:
//  ДанныеТекущейСтроки - ДанныеФормыЭлементДерева.
//
&НаКлиенте 
Процедура УстановитьИндексПиктограммыСостоянияДокументаКлиент(ДанныеТекущейСтроки)
	
	// Установим индекс пиктограммы текущего состояния документа:
	// 0 - непроведен
	// 1 - Проведен
	// 2 - помечен на удаление
	
	Если ДанныеТекущейСтроки.Проведен Тогда
		ДанныеТекущейСтроки.ИндексПиктограммы = 1;
		
	ИначеЕсли ДанныеТекущейСтроки.ПометкаУдаления Тогда
		ДанныеТекущейСтроки.ИндексПиктограммы = 2;
		
	Иначе
		ДанныеТекущейСтроки.ИндексПиктограммы = 0;
	КонецЕсли;
	
КонецПроцедуры

// бит_DKravchenko Процедура выполняет закрытие формы с предупреждением.
//
// Параметры:
//  ТекстПредупреждения - Строка.
//
&НаКлиенте
Процедура ЗакрытьФормуСПредупреждением(ТекстПредупреждения)
	
	ЭтаФорма.Закрыть();
	
	ПоказатьПредупреждение(,ТекстПредупреждения);
	
КонецПроцедуры

// бит_DKravchenko Процедура выполняет открытие текущего документа.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ОткрытьДокумент()
	
	ДанныеТекущейСтроки = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(,ДанныеТекущейСтроки.Ссылка);
	
КонецПроцедуры

// Процедура управляет доступностью кнопок.
//
&НаКлиенте 
Процедура ОбновитьДоступностьКнопок()
	
	ДанныеТекущейСтроки = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		
		ПроведениеРазрешено 		= Ложь;
		ИзменениеСостоянияРазрешено = Ложь;
		
	Иначе
		
		ТекДокументСсылка   		= ДанныеТекущейСтроки.Ссылка;
		ПроведениеРазрешено 		= ПроведениеДляДокументаРазрешено(ТекДокументСсылка);
		ИзменениеСостоянияРазрешено = ?(Не ТекДокументСсылка = ДокументСсылкаИсточник, Истина, Ложь);
		
	КонецЕсли;
	
	Элементы.ДеревоДокументовИзменитьДокумент.Доступность 		 = ИзменениеСостоянияРазрешено;
	Элементы.ДеревоДокументовИзменитьПометкуУдаления.Доступность = ИзменениеСостоянияРазрешено;
	Элементы.ДеревоДокументовПровести.Доступность 				 = ИзменениеСостоянияРазрешено
																   И ПроведениеРазрешено
																   И Не ДанныеТекущейСтроки.ПометкаУдаления;
	Элементы.ДеревоДокументовОтменаПроведения.Доступность 		 = ИзменениеСостоянияРазрешено
																   И ПроведениеРазрешено
																   И ДанныеТекущейСтроки.Проведен;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_DKravchenko Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// БИТ Amerkulov / 07042014 {
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ЗаказРасходы") Тогда
		ЗаменитьТекущийДокументНаОснование();			
	КонецЕсли;
	// }
	
	Если ДокументСсылка = Неопределено 
		Или ДокументСсылка.Пустая() Тогда
		
		Отказ = Истина;
		
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбновлениеДереваДокументов();
	
КонецПроцедуры

// БИТ Amerkulov / 07042014 {
&НаСервере 
Процедура ЗаменитьТекущийДокументНаОснование()
	
	ДокументСсылка = ДокументСсылка.ДокументОснование;
	
КонецПроцедуры
// }


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// бит_DKravchenko Процедура - обработчик команды "Изменить" формы.
//
&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьДокумент();
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик команды "ИзменитьПометкуУдаления" формы.
//
&НаКлиенте
Процедура ИзменитьПометкуУдаления(Команда)
	
	ДанныеТекущейСтроки = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДокументСсылка = ДанныеТекущейСтроки.Ссылка;
	ПометкаУдаления   = ДанныеТекущейСтроки.ПометкаУдаления;
	ИзмененаПометка   = ИзменитьПометкуУдаленияДокумента(ТекДокументСсылка, ПометкаУдаления);
	
	Если ИзмененаПометка Тогда
		
		ДанныеТекущейСтроки.Проведен 		= Ложь;
		ДанныеТекущейСтроки.ПометкаУдаления = Не ПометкаУдаления;
		
		// Установим индекс пиктограммы текущего состояния документа.
		УстановитьИндексПиктограммыСостоянияДокументаКлиент(ДанныеТекущейСтроки);
		
		ОповеститьОбИзменении(ТипЗнч(ТекДокументСсылка));
		
		ОбновитьДоступностьКнопок();
		
	КонецЕсли;

КонецПроцедуры

// бит_DKravchenko Процедура - обработчик команды "Провести" формы.
//
&НаКлиенте
Процедура Провести(Команда)
	
	ДанныеТекущейСтроки = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено
		Или ДанныеТекущейСтроки.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ТекДокументСсылка = ДанныеТекущейСтроки.Ссылка;
	ДействиеВыполнено = ПровестиДокумент(ТекДокументСсылка, РежимЗаписиДокумента.Проведение);
	
	Если ДействиеВыполнено Тогда
		
		ДанныеТекущейСтроки.Проведен = Истина;
		
		// Установим индекс пиктограммы текущего состояния документа.
		УстановитьИндексПиктограммыСостоянияДокументаКлиент(ДанныеТекущейСтроки);
		
		ОповеститьОбИзменении(ТипЗнч(ТекДокументСсылка));
		
		ОбновитьДоступностьКнопок();
		
	КонецЕсли;
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик команды "ОтменаПроведения" формы.
//
&НаКлиенте
Процедура ОтменаПроведения(Команда)
	
	ДанныеТекущейСтроки = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено
		Или ДанныеТекущейСтроки.ПометкаУдаления
		Или Не ДанныеТекущейСтроки.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	ТекДокументСсылка = ДанныеТекущейСтроки.Ссылка;
	ДействиеВыполнено = ПровестиДокумент(ТекДокументСсылка, РежимЗаписиДокумента.ОтменаПроведения);
	
	Если ДействиеВыполнено Тогда
		
		ДанныеТекущейСтроки.Проведен = Ложь;
		
		// Установим индекс пиктограммы текущего состояния документа.
		УстановитьИндексПиктограммыСостоянияДокументаКлиент(ДанныеТекущейСтроки);
		
		ОповеститьОбИзменении(ТипЗнч(ТекДокументСсылка));
		
		ОбновитьДоступностьКнопок();
		
	КонецЕсли;
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик команды "Обновить" формы.
//
&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	Если ОсновнойДокументЕщеДоступен(ДокументСсылка) Тогда
		ВыполнитьОбновлениеДереваДокументов();
	Иначе
		ЗакрытьФормуСПредупреждением("ru = 'Документ, для которого сформирован отчет о структуре
									 |подчиненности был удален, или же стал недоступен.'");
	КонецЕсли;		
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик команды "ВывестиДляТекущего" формы.
//
&НаКлиенте
Процедура ВывестиДляТекущего(Команда)
	
	ДанныеТекущейСтроки = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ДокументСсылка = ДанныеТекущейСтроки.Ссылка;
		
	Если ОсновнойДокументЕщеДоступен(ДокументСсылка) Тогда
		ВыполнитьОбновлениеДереваДокументов();
	Иначе
		ЗакрытьФормуСПредупреждением("ru = 'Документ, для которого сформирован отчет о структуре
									 |подчиненности был удален, или же стал недоступен.'");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ "ДеревоДокументов"

// бит_DKravchenko Процедура - обработчик события "ПриАктивизацииСтроки" 
// табличного поля "ДеревоДокументов".
//
&НаКлиенте
Процедура ДеревоДокументовПриАктивизацииСтроки(Элемент)
	
	ОбновитьДоступностьКнопок();
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "ПередНачаломИзменения" 
// табличного поля "ДеревоДокументов".
//
&НаКлиенте
Процедура ДеревоДокументовПередНачаломИзменения(Элемент, Отказ)	
	
	Отказ = Истина;
	
	// BIT AMerkulov 16102014 ++
	Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.бит_ФормаВводаБюджета") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);	
		
		ОткрытьФорму("Документ.бит_ФормаВводаБюджета.Форма.ФормаЗаявкаНаОперационныеРасходы", ПараметрыФормы);
		
	КонецЕсли;
  	// BIT AMerkulov 16102014 --
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// бит_DKravchenko Функция проверяет наличие документа в ИБ.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.
//
// Возвращаемое значение:
//  ДокументДоступен - Булево.
//
&НаСервереБезКонтекста
Функция ОсновнойДокументЕщеДоступен(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	Представление 
	|ИЗ 
	|	Документ." + ДокументСсылка.Метаданные().Имя + " 
	|ГДЕ 
	|	Ссылка = &ТекущийДокумент";
	
	РезультатЗапроса = Запрос.Выполнить();
	ДокументДоступен = ?(РезультатЗапроса.Пустой(), Ложь, Истина);
	
	Возврат ДокументДоступен;
	
КонецФункции

// бит_ASubbotina Процедура вывода дерева структуры подчиненности документа.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ВывестиДеревоДокументов()
	
	ДанныеДерева = ДеревоДокументов.ПолучитьЭлементы();
	ДанныеДерева.Очистить();
	
	мДерево = ДанныеДерева;	
	мУжеВСписке.Очистить();
	ВывестиРодительскиеДокументы(ДокументСсылка);
	
	ВывестиПодчиненныеДокументы(мДерево, мКэшПраваДоступаКМетаданным);
	ВывестиПодчинённыеИзТабличныхЧастей(ДокументСсылка);
	
	ВывестиДокументыОплатыПлатежныхПозиций(ДанныеДерева);
	
КонецПроцедуры // ВывестиДеревоДокументов()

// бит_DKravchenko Функция изменяет пометку удаления документа.
//
// Параметры:
//  ТекДокументСсылка - ДокументСсылка.
//  ПометкаУдаления   - Булево.
//
// Возвращаемое значение:
//   ИзмененаПометка – Булево
//
&НаСервереБезКонтекста 
Функция ИзменитьПометкуУдаленияДокумента(ТекДокументСсылка, ПометкаУдаления)
	
	ИзмененаПометка = бит_ОбщегоНазначения.ИзменитьПометкуНаУдалениеУОбъекта(ТекДокументСсылка
																			,Не ПометкаУдаления
																			,
																			,"Ошибки");
	Возврат ИзмененаПометка;
	
КонецФункции

// бит_DKravchenko Процедура выполняет проведение/отмену проведения документа.
//
// Параметры:
//  ТекДокументСсылка - ДокументСсылка.
//  РежимЗаписи 	  - РежимЗаписиДокумента.
//
// Возвращаемое значение:
//   ДействиеВыполнено – Булево
//
&НаСервереБезКонтекста 
Функция ПровестиДокумент(ТекДокументСсылка, РежимЗаписи)
	
	Попытка
		
		ДокументОбъект    = ТекДокументСсылка.ПолучитьОбъект();
		ДействиеВыполнено = бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(ДокументОбъект
																		 ,РежимЗаписи
																		 ,
																		 ,"Ошибки");
																		 
	Исключение
		
		ДействиеВыполнено = Ложь;
		
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("" + ОписаниеОшибки());
		
	КонецПопытки;
	
	Возврат ДействиеВыполнено;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_DKravchenko Процедура - обработчик события "ПриОткрытии" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ДокументСсылка", ДокументСсылка);
	Параметры.Свойство("ДокументСсылка", ДокументСсылкаИсточник);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// бит_DKravchenko Процедура устанавливает индекс пиктограммы текущего состояния документа на сервере.
//
// Параметры:
//  ДанныеТекущейСтроки - ДанныеФормыЭлементДерева.
//
&НаСервереБезКонтекста 
Процедура УстановитьИндексПиктограммыСостоянияДокументаСервер(ДанныеТекущейСтроки)
	
	// Установим индекс пиктограммы текущего состояния документа:
	// 0 - непроведен
	// 1 - Проведен
	// 2 - помечен на удаление
	
	Если ДанныеТекущейСтроки.Проведен Тогда
		ДанныеТекущейСтроки.ИндексПиктограммы = 1;
		
	ИначеЕсли ДанныеТекущейСтроки.ПометкаУдаления Тогда
		ДанныеТекущейСтроки.ИндексПиктограммы = 2;
		
	Иначе
		ДанныеТекущейСтроки.ИндексПиктограммы = 0;
	КонецЕсли;
	
КонецПроцедуры


// бит_ASubbotina Функция получает имя табличной части документа - родителя, в которой нужно искать текущий документ
//
// Параметры:
//  ДокументСсылка  - ДокументСсылка
//  
// Возвращаемое значение:
//   Строка
//
&НаСервере
Функция ПолучитьИмяТабличнойЧастиДляПоискаРодителя(ДокументСсылка)

	Если (Метаданные.Документы.Найти("бит_ЗаявкаНаРасходованиеСредств") <> Неопределено И ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ЗаявкаНаРасходованиеСредств")) 
		ИЛИ (Метаданные.Документы.Найти("бит_ПланируемоеПоступлениеДенежныхСредств") <> Неопределено И ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ПланируемоеПоступлениеДенежныхСредств")) Тогда
		ИмяТабЧастиРодителя = "ГрафикПлатежей";
		
	ИначеЕсли (Метаданные.Документы.Найти("бит_ЗаявкаНаЗатраты") <> Неопределено И ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ЗаявкаНаЗатраты")) Тогда
		ИмяТабЧастиРодителя = "ГрафикНачислений";
		
	Иначе
		ИмяТабЧастиРодителя = Неопределено;	
		
	КонецЕсли;

	Возврат ИмяТабЧастиРодителя;
	
КонецФункции // ПолучитьИмяТабличнойЧастиДляПоискаРодителя()

// бит_ASubbotina Функция добавляет элементы в список документов 
//
// Параметры:
//  СписокРеквизитов     	- СписокЗначений
//  МетаданныеДокумента  	- ОбъектМетаданных
//  МетаданныеДокументы  	- КоллекцияОбъектовМетаданных
//  мКэшМетаданныеРеквизита - Соответствие
//
&НаСервере
Процедура ДополнитьСписокДокументовПоРеквизитам(СписокРеквизитов, ДокументСсылка, МетаданныеДокумента, МетаданныеДокументы, мКэшМетаданныеРеквизита)

	Для Каждого Реквизит ИЗ МетаданныеДокумента.Реквизиты Цикл
		ТипыРеквизита = Реквизит.Тип.Типы();
		Для Каждого ТекущийТип ИЗ ТипыРеквизита Цикл
			МетаданныеРеквизита = мКэшМетаданныеРеквизита.Получить(ТекущийТип);
			Если МетаданныеРеквизита = неопределено Тогда
				МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
				мКэшМетаданныеРеквизита.Вставить(ТекущийТип,МетаданныеРеквизита);
			КонецЕсли;
					
			Если МетаданныеРеквизита<>Неопределено 
				 И МетаданныеДокументы.Содержит(МетаданныеРеквизита) 
				 И ПравоДоступа("Чтение", МетаданныеРеквизита) Тогда
				Попытка
					ЗначениеРеквизита = ДокументСсылка[Реквизит.Имя];
				Исключение
					Прервать;
				КонецПопытки;
				ЕСли ЗначениеРеквизита<>Неопределено И НЕ ЗначениеРеквизита.Пустая() И ТипЗнч(ЗначениеРеквизита) = ТекущийТип 
					 И мУжеВСписке[ЗначениеРеквизита] = Неопределено И СписокРеквизитов.НайтиПоЗначению(ДокументСсылка[Реквизит.Имя]) = Неопределено Тогда
					Попытка
						СписокРеквизитов.Добавить(ЗначениеРеквизита,Формат(ЗначениеРеквизита.Дата,"ДФ=yyyyMMddЧЧММсс"));
					Исключение
						 ОтладкаТекстОшибки = ОписаниеОшибки();
					КонецПопытки;	
				КонецЕсли;
			КонецЕсли;			
			
		КонецЦикла;
	КонецЦикла;	
		
КонецПроцедуры // ДополнитьСписокДокументовПоРеквизитам()

// бит_ASubbotina Функция добавляет элементы в список документов из табличных частей
//
// Параметры:
//  СписокРеквизитов     - СписокЗначений
//  МетаданныеДокумента  - ОбъектМетаданных
//  МетаданныеДокументы  - КоллекцияОбъектовМетаданных
//
&НаСервере
Процедура ДополнитьСписокДокументовПоТабличнымЧастям(СписокРеквизитов, ДокументСсылка, МетаданныеДокумента, МетаданныеДокументы)

	Для Каждого ТЧ Из МетаданныеДокумента.ТабличныеЧасти Цикл
		
		СтрРеквизитов = "";
		
		Попытка
			СодержимоеТЧ = ДокументСсылка[ТЧ.Имя].Выгрузить();
		Исключение
			Прервать;
		КонецПопытки;
		
		Для Каждого Реквизит ИЗ ТЧ.Реквизиты Цикл
			ТипыРеквизита = Реквизит.Тип.Типы();
			Для Каждого ТекущийТип ИЗ ТипыРеквизита Цикл
				МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);				
				Если МетаданныеРеквизита<>Неопределено И МетаданныеДокументы.Содержит(МетаданныеРеквизита) 
					И ПравоДоступа("Чтение", МетаданныеРеквизита) Тогда
					СтрРеквизитов = СтрРеквизитов + ?(СтрРеквизитов = "", "", ", ") + Реквизит.Имя;
					Прервать;
				КонецЕсли;						
			КонецЦикла;
		КонецЦикла;
		
		Попытка
		СодержимоеТЧ.Свернуть(СтрРеквизитов);
		Исключение
		КонецПопытки;
		
		Для Каждого КолонкаТЧ ИЗ СодержимоеТЧ.Колонки Цикл
			Для Каждого СтрокаТЧ ИЗ СодержимоеТЧ Цикл
				Попытка
					ЗначениеРеквизита = СтрокаТЧ[КолонкаТЧ.Имя];
				Исключение
					Продолжить;
				КонецПопытки;
				МетаданныеЗначения = Метаданные.НайтиПоТипу(ТипЗнч(ЗначениеРеквизита));
				Если МетаданныеЗначения = Неопределено Тогда
					// базовый тип
					Продолжить;
				КонецЕсли;
				
				ЕСли ЗначениеРеквизита<>Неопределено И НЕ ЗначениеРеквизита.Пустая()
					 И МетаданныеДокументы.Содержит(МетаданныеЗначения)
					 И мУжеВСписке[ЗначениеРеквизита] = Неопределено Тогда
					Если СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено Тогда
						Попытка
							СписокРеквизитов.Добавить(ЗначениеРеквизита,Формат(ЗначениеРеквизита.Дата,"ДФ=yyyyMMddЧЧММсс"));
						Исключение
							ОтладкаТекстОшибки = ОписаниеОшибки();
						КонецПопытки;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;		
	КонецЦикла;
			
КонецПроцедуры // ДополнитьСписокДокументовПоТабличнымЧастям()

// бит_ASubbotina Функция добавляет элементы в список документов 
//
// Параметры:
//  СписокРеквизитов     	- СписокЗначений
//  ДокументСсылка          - ДокументСсылка
//  ИмяТабЧастиРодителя  	- Строка
//
&НаСервере
Процедура ДобавитьСтрокуРодителя(СписокРеквизитов, ДокументСсылка, ИмяТабЧастиРодителя)

	МетаданныеДокумента = ДокументСсылка.Метаданные();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументПланирования", ДокументСсылка);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_ДопУсловияПоДоговоруТч.Ссылка,
	|	бит_ДопУсловияПоДоговоруТч.Ссылка.Проведен,
	|	бит_ДопУсловияПоДоговоруТч.Ссылка.ПометкаУдаления,
	|	бит_ДопУсловияПоДоговоруТч.Ссылка.Представление,
	|	бит_ДопУсловияПоДоговоруТч.Ссылка.ВалютаДокумента,
	|	NULL КАК СуммаДокумента
	|ИЗ
	|	Документ.бит_ДополнительныеУсловияПоДоговору." + ИмяТабЧастиРодителя + " КАК бит_ДопУсловияПоДоговоруТч
	|ГДЕ
	|	бит_ДопУсловияПоДоговоруТч.ДокументПланирования = &ДокументПланирования
	|";
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СсылкаНаДокумент = Выборка.Ссылка;
		ВывестиРодительскиеДокументы(СсылкаНаДокумент);
				
	КонецЦикла;
	
КонецПроцедуры // ДобавитьСтрокуРодителя()

// Процедура выполняет вывод родительских документов.
//
&НаСервере
Процедура ВывестиРодительскиеДокументы(ДокументСсылка)
	
	МетаданныеДокумента 	= ДокументСсылка.Метаданные();
	СписокРеквизитов 		= Новый СписокЗначений;
	МетаданныеДокументы 	= Метаданные.Документы; 
	мКэшМетаданныеРеквизита = Новый соответствие;
	
	//БИТ Тртилек 26092013 для ПТиУ по КЗ не нужно выводить документы из ТЧ
	//РеквизитыТчПодчинённые = ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ДополнительныеУсловияПоДоговору");
	РеквизитыТчПодчинённые = ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ДополнительныеУсловияПоДоговору")
	                         ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_му_ПоступлениеТоваровУслугПоКЗ");
	///БИТ Тртилек							 
	ИмяТабЧастиРодителя    = ПолучитьИмяТабличнойЧастиДляПоискаРодителя(ДокументСсылка);
	
	ДополнитьСписокДокументовПоРеквизитам(СписокРеквизитов, ДокументСсылка, МетаданныеДокумента, МетаданныеДокументы, мКэшМетаданныеРеквизита);
	Если Не РеквизитыТчПодчинённые Тогда 		
		ДополнитьСписокДокументовПоТабличнымЧастям(СписокРеквизитов, ДокументСсылка, МетаданныеДокумента, МетаданныеДокументы);		
	КонецЕсли; // если надо выводить реквизиты табличной части в качестве родителей
	Если СписокРеквизитов.Количество() = 0 И ИмяТабЧастиРодителя <> Неопределено Тогда
		ДобавитьСтрокуРодителя(СписокРеквизитов, ДокументСсылка, ИмяТабЧастиРодителя);	
	КонецЕсли;
		
	СписокРеквизитов.СортироватьПоПредставлению();
	мУжеВСписке.Вставить(ДокументСсылка, Истина);
	
	Если СписокРеквизитов.Количество() = 1 Тогда
		ВывестиРодительскиеДокументы(СписокРеквизитов[0].Значение);
	ИначеЕсли СписокРеквизитов.Количество() > 1 Тогда
		ВывестиБезРодителей(СписокРеквизитов);		
	КонецЕсли;

	Если ТипЗнч(мДерево) = Тип("ДанныеФормыЭлементДерева") Тогда
		СтрокаДерева = мДерево.ПолучитьЭлементы().Добавить();
	Иначе
		СтрокаДерева = мДерево.Добавить();
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ Ссылка, Проведен, ПометкаУдаления, #Сумма, #Валюта, Представление, """ + МетаданныеДокумента.Имя + """ КАК Метаданные
						   | ИЗ Документ."+МетаданныеДокумента.Имя + " ГДЕ Ссылка = &Ссылка");
						   
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Если МетаданныеДокумента.Реквизиты.Найти("СуммаДокумента") <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Сумма", "СуммаДокумента КАК СуммаДокумента");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Сумма", "NULL КАК СуммаДокумента");
	КонецЕсли;
	
	Если МетаданныеДокумента.Реквизиты.Найти("ВалютаДокумента") <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Валюта", "ВалютаДокумента КАК ВалютаДокумента");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Валюта", "NULL КАК ВалютаДокумента");
	КонецЕсли;
	
	Выборка  = Запрос.Выполнить().Выбрать();
	ЕСли Выборка.Следующий() Тогда		
		
		СтрокаДерева.Ссылка   		 = Выборка.Ссылка;
		СтрокаДерева.Проведен 		 = Выборка.Проведен;
		СтрокаДерева.ПометкаУдаления = Выборка.ПометкаУдаления;
		
		// Установим индекс пиктограммы текущего состояния документа.
		УстановитьИндексПиктограммыСостоянияДокументаСервер(СтрокаДерева);
		
		СтрокаДерева.ДокументПредставление = Выборка.Представление;
		Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ПроектДоговора") Тогда
			Если СтрокаДерева.ПолучитьРодителя() = Неопределено Тогда
				СтрокаДерева.ДокументПредставление = СтрЗаменить(СтрокаДерева.ДокументПредставление
														, СтрокаДерева.Ссылка.Метаданные().ПредставлениеОбъекта, "Проект договора");
			Иначе
				СтрокаДерева.ДокументПредставление = СтрЗаменить(СтрокаДерева.ДокументПредставление
														, СтрокаДерева.Ссылка.Метаданные().ПредставлениеОбъекта, "Доп. соглашение");
			КонецЕсли;
		КонецЕсли;
		СтрокаДерева.СуммаДокумента  = Выборка.СуммаДокумента;
		СтрокаДерева.ВалютаДокумента = Выборка.ВалютаДокумента;
		
	Иначе
		
		СтрокаДерева.Ссылка= ДокументСсылка;
		СтрокаДерева.ДокументПредставление = Строка(ДокументСсылка);
		СтрокаДерева.СуммаДокумента 	   = ДокументСсылка.СуммаДокумента;
		
	КонецЕсли;
	
	мДерево = СтрокаДерева;
		
КонецПроцедуры // ВывестиРодительскиеДокументы()

// Процедура осуществляет вывод родительских документов с ограничением по уровню в дереве.
//
&НаСервере
Процедура ВывестиБезРодителей(СписокДокументов, ВывестиПодчиненные = Ложь)
	
	Если ТипЗнч(мДерево) = Тип("ДанныеФормыЭлементДерева") Тогда
		СтрокиДерева = мДерево.ПолучитьЭлементы();
	Иначе
		СтрокиДерева = мДерево;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокДокументов Цикл
		
		МетаданныеДокумента = ЭлементСписка.Значение.Метаданные();
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ Ссылка, Проведен, ПометкаУдаления, #Сумма, #Валюта, Представление, """ + МетаданныеДокумента.Имя + """ КАК Метаданные
		| ИЗ Документ."+МетаданныеДокумента.Имя + " ГДЕ Ссылка = &Ссылка");
		
		Запрос.УстановитьПараметр("Ссылка", ЭлементСписка.Значение);
		
		Если МетаданныеДокумента.Реквизиты.Найти("СуммаДокумента") <> Неопределено Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Сумма", "СуммаДокумента КАК СуммаДокумента");
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Сумма", "NULL КАК СуммаДокумента");
		КонецЕсли;
		
		Если МетаданныеДокумента.Реквизиты.Найти("ВалютаДокумента") <> Неопределено Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Валюта", "ВалютаДокумента КАК ВалютаДокумента");
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Валюта", "NULL КАК ВалютаДокумента");
		КонецЕсли;
		
		Выборка  = Запрос.Выполнить().Выбрать();
		ЕСли Выборка.Следующий() Тогда		
			
			Если мУжеВСписке[Выборка.Ссылка] = Неопределено Тогда
				
	            СтрокаДерева = СтрокиДерева.Добавить();
				СтрокаДерева.Ссылка= Выборка.Ссылка;
				СтрокаДерева.Проведен = Выборка.Проведен;
				СтрокаДерева.ПометкаУдаления = Выборка.ПометкаУдаления;
				
				// Установим индекс пиктограммы текущего состояния документа.
				УстановитьИндексПиктограммыСостоянияДокументаСервер(СтрокаДерева);
				
				СтрокаДерева.ДокументПредставление = Выборка.Представление;
				СтрокаДерева.СуммаДокумента 	   = Выборка.СуммаДокумента;
				СтрокаДерева.ВалютаДокумента 	   = Выборка.ВалютаДокумента;
				мУжеВСписке.Вставить(Выборка.Ссылка, Истина);
				
				Если ВывестиПодчиненные Тогда
					ВывестиПодчиненныеДокументы(СтрокаДерева, мКэшПраваДоступаКМетаданным);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;		
		
	КонецЦикла;

	мДерево = СтрокаДерева;
	
КонецПроцедуры // ВывестиБезРодителей()

// Процедура осуществляет вывод подчиненных документов.
//
&НаСервере
Процедура ВывестиПодчиненныеДокументы(СтрокаДерева, мКэшПраваДоступаКМетаданным)
	
	ТекущийДокумент = СтрокаДерева.Ссылка;	
	// бит_DKravchenko изменение кода. Начало. 15.01.2010{{ 
	Таблица = бит_ПолныеПрава.ПолучитьСписокПодчиненныхДокументов(ТекущийДокумент, мКэшПраваДоступаКМетаданным, "бит_СтруктураПодчиненностиТонкийКлиент");
	// бит_DKravchenko изменение кода. Конец. 15.01.2010}} 
	КэшПоТипамДокументов = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл
		МетаданныеДокумента = СтрокаТаблицы.Ссылка.Метаданные();
		Если Не ПравоДоступа("Чтение", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;			
		ИмяДокумента = МетаданныеДокумента.Имя;
		СинонимДокумента = МетаданныеДокумента.Синоним;
		
		ДополнитьКэшМетаданных(МетаданныеДокумента, ИмяДокумента, мКэшРеквизитовДокумента);
		
		СтруктураТипа = КэшПоТипамДокументов[ИмяДокумента];
		Если СтруктураТипа = Неопределено Тогда
			СтруктураТипа = Новый Структура("Синоним, МассивСсылок", СинонимДокумента, Новый Массив);
			КэшПоТипамДокументов.Вставить(ИмяДокумента, СтруктураТипа);
		КонецЕсли;
		СтруктураТипа.МассивСсылок.Добавить(СтрокаТаблицы.Ссылка);		
	КонецЦикла;
	
	Если КэшПоТипамДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапросаНачало = "ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ (";
	ТекстЗапросаКонец = ") КАК ПодчиненныеДокументы УПОРЯДОЧИТЬ ПО ПодчиненныеДокументы.Дата";
	Запрос = Новый Запрос;
	Для Каждого КлючИЗначение ИЗ КэшПоТипамДокументов Цикл
		Запрос.Текст = Запрос.Текст + ?(Запрос.Текст = "", "
					|ВЫБРАТЬ ", "
					|ОБЪЕДИНИТЬ ВСЕ
					|ВЫБРАТЬ") + "
					|Дата, Ссылка, Представление, Проведен, ПометкаУдаления, 
					|" + ?(мКэшРеквизитовДокумента[КлючИЗначение.Ключ]["СуммаДокумента"], "СуммаДокумента", "NULL") + " КАК СуммаДокумента,
					|" + ?(мКэшРеквизитовДокумента[КлючИЗначение.Ключ]["ВалютаДокумента"], "ВалютаДокумента", "NULL") + " КАК ВалютаДокумента
					|ИЗ Документ." + КлючИЗначение.Ключ + "
					|ГДЕ Ссылка В (&" + КлючИЗначение.Ключ + ")";
					
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение.МассивСсылок);		
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапросаНачало + Запрос.Текст + ТекстЗапросаКонец;
	
	Если ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыЭлементДерева") Тогда
		СтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
	Иначе
		СтрокиДерева = СтрокаДерева;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Пока Выборка.Следующий() Цикл
		
		Если мУжеВСписке[Выборка.Ссылка] = Неопределено Тогда
			
			НоваяСтрока = СтрокиДерева.Добавить();
			НоваяСтрока.Ссылка 				  = Выборка.Ссылка;
			НоваяСтрока.ДокументПредставление = Выборка.Представление;
			Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.бит_ПроектДоговора") Тогда
				НоваяСтрока.ДокументПредставление = СтрЗаменить(НоваяСтрока.ДокументПредставление, НоваяСтрока.Ссылка.Метаданные().ПредставлениеОбъекта, "Доп. соглашение");
			КонецЕсли;
			НоваяСтрока.СуммаДокумента 		  = Выборка.СуммаДокумента;
			НоваяСтрока.ВалютаДокумента 	  = Выборка.ВалютаДокумента;
			НоваяСтрока.Проведен 			  = Выборка.Проведен;
			НоваяСтрока.ПометкаУдаления 	  = Выборка.ПометкаУдаления;		
			
			// Установим индекс пиктограммы текущего состояния документа.
			УстановитьИндексПиктограммыСостоянияДокументаСервер(НоваяСтрока);
			
			мУжеВСписке.Вставить(Выборка.Ссылка, Истина);
			ВывестиПодчиненныеДокументы(НоваяСтрока,мКэшПраваДоступаКМетаданным);
			
			ТемпДерево = мДерево;
			мДерево    = НоваяСтрока;
			ВывестиПодчинённыеИзТабличныхЧастей(НоваяСтрока.Ссылка);
			мДерево = ТемпДерево;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВывестиПодчиненныеДокументы()

// бит_DFedotov Процедура находит по платежным позициям документы оплаты и выводит их в дерево
//
// Параметры:
//	ДанныеДерева - ДанныеФормыКоллекцияЭлементовДерева
//	
&НаСервере
Процедура ВывестиДокументыОплатыПлатежныхПозиций(ДанныеДерева)
	
	МассивПлатежныхПозиций = Новый Массив;
	
	// найдем платежные позиции в дереве
	Для Каждого ТекДокумент Из мУжеВСписке Цикл
		
		Если Метаданные.Документы.Найти("бит_ПлатежнаяПозиция") <> Неопределено И ТипЗнч(ТекДокумент.Ключ) = Тип("ДокументСсылка.бит_ПлатежнаяПозиция") Тогда
			
			МассивПлатежныхПозиций.Добавить(ТекДокумент.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивПлатежныхПозиций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеДокументов = бит_Казначейство.ПолучитьСоответствиеПлатежныхПозицийИДокументовОплаты(МассивПлатежныхПозиций);
	
	Если СоответствиеДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВывестиДокументыОплаты(ДанныеДерева, СоответствиеДокументов);
	
КонецПроцедуры

// бит_DFedotov Процедура выводит найденные документы оплаты по платежным позициям в дерево
//	Вызывается рекурсивно.
//
// Параметры:
//	ЭлементыСтроки - ДанныеФормыКоллекцияЭлементовДерева
//	СоответствиеДокументов - Соответствие
//
&НаСервере
Процедура ВывестиДокументыОплаты(ЭлементыСтроки, СоответствиеДокументов)
	
	Для Каждого ТекСтрока Из ЭлементыСтроки Цикл
		
		ДокументОплаты = СоответствиеДокументов[ТекСтрока.Ссылка];
		
		ПодчиненныеСтроки = ТекСтрока.ПолучитьЭлементы();
		
		Если НЕ ДокументОплаты = Неопределено Тогда
			
			МетаданныеДокумента = ДокументОплаты.Метаданные();
			
			ИмяДокумента = МетаданныеДокумента.Имя;
			
			Если мКэшРеквизитовДокумента[ИмяДокумента] = Неопределено Тогда
				ДополнитьКэшМетаданных(МетаданныеДокумента, ИмяДокумента, мКэшРеквизитовДокумента);
			КонецЕсли;
			
			НоваяСтрока = ПодчиненныеСтроки.Добавить();
			
			НоваяСтрока.Ссылка = ДокументОплаты;
			НоваяСтрока.ДокументПредставление = Строка(ДокументОплаты);
			НоваяСтрока.СуммаДокумента = ?(мКэшРеквизитовДокумента[ИмяДокумента]["СуммаДокумента"], ДокументОплаты.СуммаДокумента, 0);
			НоваяСтрока.ВалютаДокумента = ?(мКэшРеквизитовДокумента[ИмяДокумента]["ВалютаДокумента"], ДокументОплаты.ВалютаДокумента, Неопределено);
			НоваяСтрока.Проведен = ДокументОплаты.Проведен;
			НоваяСтрока.ПометкаУдаления = ДокументОплаты.ПометкаУдаления;
			
			// Установим индекс пиктограммы текущего состояния документа.
			УстановитьИндексПиктограммыСостоянияДокументаСервер(НоваяСтрока);
			
			мУжеВСписке.Вставить(ДокументОплаты, Истина);
			ВывестиПодчиненныеДокументы(НоваяСтрока,мКэшПраваДоступаКМетаданным);
		КонецЕсли;
		
		ВывестиДокументыОплаты(ПодчиненныеСтроки, СоответствиеДокументов);
		
	КонецЦикла;
	
КонецПроцедуры

// бит_ASubbotina Процедура выводит подчинённые записанные в табличных частях
//
// Параметры:
//  Параметр1  - Тип_описание
//  Параметр2  - Тип_описание
//
&НаСервере
Процедура ВывестиПодчинённыеИзТабличныхЧастей(ДокументСсылка)

	РеквизитыТчПодчинённые = ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.бит_ДополнительныеУсловияПоДоговору");
		
	Если Не РеквизитыТчПодчинённые Тогда
		Возврат;
	КонецЕсли;
		
	МетаданныеДокумента = ДокументСсылка.Метаданные();
	СписокРеквизитов 	= Новый СписокЗначений;
	МетаданныеДокументы = Метаданные.Документы;
	
	ДополнитьСписокДокументовПоТабличнымЧастям(СписокРеквизитов, ДокументСсылка, МетаданныеДокумента, МетаданныеДокументы);
    ВывестиБезРодителей(СписокРеквизитов, Истина);

КонецПроцедуры // ВывестиПодчинённыеИзТабличныхЧастей()


// Процедура дополняет кэш метаданных для документа.
//
&НаСервереБезКонтекста
Процедура ДополнитьКэшМетаданных(МетаданныеДокумента, ИмяДокумента, мКэшРеквизитовДокумента)
	
	РеквизитыДокумента = мКэшРеквизитовДокумента[ИмяДокумента];
	
	Если РеквизитыДокумента = Неопределено Тогда
		
		РеквизитыДокумента = Новый Соответствие;		
		РеквизитыДокумента.Вставить("СуммаДокумента" , МетаданныеДокумента.Реквизиты.Найти("СуммаДокумента")  <> Неопределено);
		РеквизитыДокумента.Вставить("ВалютаДокумента", МетаданныеДокумента.Реквизиты.Найти("ВалютаДокумента") <> Неопределено);		
		
		мКэшРеквизитовДокумента.Вставить(ИмяДокумента, РеквизитыДокумента);
		
	КонецЕсли;
	
КонецПроцедуры

// бит_DKravchenko Функция проверяет возможность проведения ля документа.
//
// Параметры:
//  ТекДокументСсылка - ДокументСсылка.
//
&НаСервереБезКонтекста 
Функция ПроведениеДляДокументаРазрешено(ТекДокументСсылка)
	
	ПроведениеРазрешено = ?(ТекДокументСсылка.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить
						   ,Истина
						   ,Ложь);
	
	Возврат ПроведениеРазрешено;
	
КонецФункции

// BIT Amerkulov 14042014 {
&НаКлиенте
Процедура ДеревоДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.бит_ФормаВводаБюджета") Тогда
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);	
		
	ОткрытьФорму("Документ.бит_ФормаВводаБюджета.Форма.ФормаЗаявкаНаОперационныеРасходы", ПараметрыФормы);
	
	// ОКЕЙ Гиль А.В.(Софтлаб) Начало 26.01.2020 (#3591)
    Иначе 
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
	// ОКЕЙ Гиль А.В.(Софтлаб) Конец 26.01.2020 (#3591)
		
	КонецЕсли;
КонецПроцедуры
 // }


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мУжеВСписке 				= Новый Соответствие;
мКэшРеквизитовДокумента 	= Новый Соответствие;
мКэшПраваДоступаКМетаданным	= Новый Соответствие;
