
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	ПолноеИмяОбъекта = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКэшЗначений();
	
	// Проверка дополнительного права на работы со всеми заместителями.
	ТекПользователь = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("ТекущийПользователь");
	
	флАдмин = бит_ПраваДоступа.ПолучитьЗначениеДопПраваПользователя(ТекПользователь
	                              ,ПланыВидовХарактеристик.бит_ДополнительныеПраваПользователей.РазрешеноАдминистрированиеЗаместителей);
	
	
	АдресСКД = Обработки.бит_НазначениеЗаместителей.ИнициализироватьКомпоновщик(Компоновщик, УникальныйИдентификатор, флАдмин);
	
	// Восстановление настройки по-умолчанию
	УстановитьЗначенияПоУмолчанию();	
	
								  
								  
    Если НЕ флАдмин Тогда
	
		Объект.Пользователь = ТекПользователь;
	    Элементы.Пользователь.Видимость = Истина;
		Элементы.Пользователь.ТолькоПросмотр = Истина;
		
	Иначе
		
		Элементы.Пользователь.Видимость = Ложь;
		
	КонецЕсли; 								  
	
	УстановитьЗаголовокФормыСервер();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Видимость панели настроек
	Элементы.ФормаКомандаПанельНастроек.Пометка = Не фСкрытьПанельНастроек;		
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДереводанные

&НаКлиенте
Процедура ДеревоДанныеЗаместительПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "Заместитель", ТекущаяСтрока.Заместитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДанныеЗаместительОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "Заместитель", ТекущаяСтрока.Заместитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДанныеДатаНачалаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "ДатаНачала", ТекущаяСтрока.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДанныеДатаНачалаОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "ДатаНачала", ТекущаяСтрока.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДанныеДатаОкончанияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "ДатаОкончания", ТекущаяСтрока.ДатаОкончания);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДанныеДатаОкончанияОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "ДатаОкончания", ТекущаяСтрока.ДатаОкончания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	// Отбор для поиска текущей строки после обновления.
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		СтрОтбор = Новый Структура("Пользователь, ПредставлениеГруппировки", ТекущаяСтрока.Пользователь, ТекущаяСтрока.ПредставлениеГруппировки);			
	Иначе	
		СтрОтбор = Новый Структура("Пользователь, ПредставлениеГруппировки", "ПустойПользователь", "ПустаяГруппировка");
	КонецЕсли; 
	
    ЗаписатьДанные(СтрОтбор);
	
	бит_РаботаСДиалогамиКлиент.РазвернутьДеревоПолностью(Элементы.ДеревоДанные, ДеревоДанные.ПолучитьЭлементы(),Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	СтрОтбор = Новый Структура("Пользователь, ПредставлениеГруппировки");			
	
	ОбновитьДерево(СтрОтбор);
	
	бит_РаботаСДиалогамиКлиент.РазвернутьДеревоПолностью(Элементы.ДеревоДанные, ДеревоДанные.ПолучитьЭлементы(),Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПанельНастроек(Команда)
	
	фСкрытьПанельНастроек = Не фСкрытьПанельНастроек;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаКопировать(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено И ТекущаяСтрока.ЭтоДетальнаяЗапись Тогда
		
		// Копирование текущей строки дерева
		 СтрокаРодитель = ТекущаяСтрока.ПолучитьРодителя();
		 КоллекцияВерх = СтрокаРодитель.ПолучитьЭлементы();
		 
		 НовЭлемент = КоллекцияВерх.Добавить();
		 ЗаполнитьЗначенияСвойств(НовЭлемент, ТекущаяСтрока);
		 НовЭлемент.Заместитель           = Неопределено;
		 НовЭлемент.ЗаместительПредыдущий = Неопределено;
		 НовЭлемент.Состояние     = Неопределено;
		 НовЭлемент.ДатаНачала    = Неопределено;
		 НовЭлемент.ДатаОкончания = Неопределено;
		 НовЭлемент.ЗамАктивен    = Ложь;
		 НовЭлемент.Скопирована   = Истина;
		 
		 Элементы.ДеревоДанные.ТекущаяСтрока = НовЭлемент.ПолучитьИдентификатор();
		 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалить(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено И ТекущаяСтрока.ЭтоДетальнаяЗапись И ТекущаяСтрока.Скопирована Тогда
		
		// Копирование текущей строки дерева
		 СтрокаРодитель = ТекущаяСтрока.ПолучитьРодителя();
		 КоллекцияВерх  = СтрокаРодитель.ПолучитьЭлементы();
		 Инд = КоллекцияВерх.Индекс(ТекущаяСтрока);
		 КоллекцияВерх.Удалить(Инд);
		 
	Иначе
		 
		ТекстСообщения = НСтр("en = 'This string cannot be deleted.'; ru = 'Строка не может быть удалена.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		 
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСНастройками

// Процедура - действие команды "КомандаСохранитьНастройки".
// 
&НаКлиенте
Процедура КомандаСохранитьНастройки(Команда)
	
	ПараметрыФормы     = Новый Структура;
	СтруктураНастройки = УпаковатьНастройкиВСтруктуру();
	ПараметрыФормы.Вставить("СтруктураНастройки" , СтруктураНастройки);
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
	
		ПараметрыФормы.Вставить("СохраненнаяНастройка",ТекущаяНастройка);
	
	КонецЕсли; 
	
	Оповещение = Новый ОписаниеОповещения("СохранитьНастройки",ЭтаФорма);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаСохранения", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры // КомандаСохранитьНастройки()

// Процедура - обработчик оповещения о закрытии формы сохранения настроек. 
// 
&НаКлиенте
Процедура СохранитьНастройки(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		ТекущаяНастройка = Результат;
		УстановитьЗаголовокФормы();
		
	КонецЕсли;
	
КонецПроцедуры // СохранитьНастройки()

// Процедура - действие команды "КомандаВосстановитьНастройки".
// 
&НаКлиенте
Процедура КомандаВосстановитьНастройки(Команда)
	
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Оповещение = Новый ОписаниеОповещения("ПрименениеНастроек",ЭтаФорма);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаЗагрузки", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры // КомандаВосстановитьНастройки()

// Процедура - обработчик оповещения о закрытии формы применения настроек. 
// 
&НаКлиенте 
Процедура ПрименениеНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда        
		
		ПрименитьНастройки(Результат);
		
	КонецЕсли;	
	
КонецПроцедуры // ПрименениеНастроек

// Функция готовит стуктуру с настройками для сохранения.
// 
// Возвращаемое значение:
//   СтруктураНастройки   - Структура.
// 
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()

	СтруктураНастройки = Новый Структура;
	
	СтруктураНастройки.Вставить("ПользовательскиеНастройки", Новый ХранилищеЗначения(Компоновщик.ПользовательскиеНастройки));
	
	Возврат СтруктураНастройки;
	
КонецФункции // УпаковатьНастройкиВСтруктуру()

// Функция применяет сохраненные настройки.
// 
// Параметры:
//  ВыбНастройка  - СправочникСсылка.бит_СохраненныеНастройки.
// 
&НаСервере
Функция ПрименитьНастройки(ВыбНастройка)

	флВыполнено = Ложь;
	
	Если ЗначениеЗаполнено(ВыбНастройка) Тогда
		
		СтруктураНастроек = ВыбНастройка.ХранилищеНастроек.Получить();
		
		Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
			
			// Загрузки пользовательских настроек
			ПользовательскиеНастройки = СтруктураНастроек.ПользовательскиеНастройки.Получить();
			
			Если ТипЗнч(ПользовательскиеНастройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
				
				Компоновщик.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
				
			КонецЕсли; // Это пользовательские настройки
			
			ТекущаяНастройка = ВыбНастройка;
			УстановитьЗаголовокФормыСервер();				
			
		КонецЕсли;	 
		
	КонецЕсли; 
	
	УстановитьВидимость();
	 
	 Возврат флВыполнено;
	 
КонецФункции // ПрименитьНастройки()

// Процедура устанавливает настройку либо из последних использованных, либо из настройки по умолчанию.
// 
&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	// Получим настройку по - умолчанию и последнюю использованну.
	//НастройкаПоУмолчанию = бит_ОтчетыСервер.НайтиНастройкуПоУмолчаниюДляОбъекта(фКэшЗначений.НастраиваемыйОбъект);
	//
	//Если ЗначениеЗаполнено(НастройкаПоУмолчанию) Тогда		
	//	ПрименитьНастройки(НастройкаПоУмолчанию);		
	//КонецЕсли; 
	
КонецПроцедуры // УстановитьЗначенияПоУмолчанию()

#КонецОбласти

#Область ПрочиеСерверныеПроцедурыИФункции

// Процедура кеширует значения, в дальнейшем используемые на клиенте. 
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	
	фКэшЗначений.Вставить("ТекущийПользователь"		 , бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
	фКэшЗначений.Вставить("НастраиваемыйОбъект"		 , Метаданные.Обработки.бит_НазначениеЗаместителей.ПолноеИмя());
	фКэшЗначений.Вставить("ТипНастройки"             , Перечисления.бит_ТипыСохраненныхНастроек.Обработки);
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура устанавливает заголовок формы на сервере.
// 
&НаСервере
Процедура УстановитьЗаголовокФормыСервер()
	
	ЭтаФорма.Заголовок = СформироватьЗаголовокФормы(ТекущаяНастройка);
	
КонецПроцедуры // УстановитьЗаголовокФормыСервер()

// Процедура выполняет обновление дерева данных.
// 
&НаСервере
Функция ОбновитьДерево(СтрОтбор)
	
	ДеревоДанные.ПолучитьЭлементы().Очистить();
	
	Если ЗначениеЗаполнено(Объект.Пользователь) Тогда
	
		//эо = Компоновщик.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		//эо.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		//эо.Использование = Истина;
		//эо.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Пользователь");
		//эо.ПравоеЗначение = Объект.Пользователь;
	
	КонецЕсли; 
	
	ДеревоВрем = Обработки.бит_НазначениеЗаместителей.НастройкиЗаместителей(Компоновщик, АдресСКД);
	
	ТекИД = 0;
	ОбойтиДеревоВрем(ДеревоВрем, ДеревоДанные.ПолучитьЭлементы(),СтрОтбор, ТекИД);
	
	Возврат ТекИД;
	
КонецФункции // ОбновитьДерево()

// Процедура обходит дерево значений и заполняет дерево, размещенное на форме.
// 
&НаСервере
Процедура ОбойтиДеревоВрем(ВхСтрока, ВхКоллекцияФормы, СтрОтбор, ТекИД)

	Для каждого ТекСтрока Из ВхСтрока.Строки Цикл
		
		НовЭлементКоллекции = ВхКоллекцияФормы.Добавить();
		ЗаполнитьЗначенияСвойств(НовЭлементКоллекции, ТекСтрока);
		
		Если СтрОтбор.Пользователь = НовЭлементКоллекции.Пользователь
			 И СтрОтбор.ПредставлениеГруппировки = НовЭлементКоллекции.ПредставлениеГруппировки Тогда
		
			 ТекИД = НовЭлементКоллекции.ПолучитьИдентификатор();
		
		КонецЕсли; 
		
		ОбойтиДеревоВрем(ТекСтрока, НовЭлементКоллекции.ПолучитьЭлементы(),СтрОтбор,ТекИД);
	
	КонецЦикла; 

КонецПроцедуры // ОбойтиДеревоВрем()

// Процедура выполняет запись данных об установленных заместителях.
// 
&НаСервере
Процедура ЗаписатьДанные(СтрОтбор)

	ЗаписатьДанныеПоУровню(ДеревоДанные);

	ТекИД = ОбновитьДерево(СтрОтбор);
	
	Элементы.ДеревоДанные.ТекущаяСтрока = ТекИД;				
	
КонецПроцедуры // ЗаписатьДанные()

// Функция .
// 
// Параметры:
//   ВхСтрока - ДанныеФормыЭлементДерева.
// 
// Возвращаемое значение:
//  НайденнаяСтрока - ДанныеФормыЭлементДерева.
// 
&НаСервере
Функция ПоискИерархический(ВхСтрока, СтрОтбор)
	
	НайденнаяСтрока = Неопределено;
	Коллекция       = ВхСтрока.ПолучитьЭлементы();
	
	Для каждого ТекущаяСтрока Из Коллекция Цикл
		
		Если ТекущаяСтрока.Пользователь = СтрОтбор.Пользователь 
			И ТекущаяСтрока.ПредставлениеГруппировки = ТекущаяСтрока.ПредставлениеГруппировки Тогда
			
			НайденнаяСтрока = ТекущаяСтрока;
			Прервать;
			
		КонецЕсли; 
		
		НайденнаяСтрока = ПоискИерархический(ТекущаяСтрока, СтрОтбор);
		
		Если НЕ НайденнаяСтрока = Неопределено Тогда
		
			Прервать;
		
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат НайденнаяСтрока;
	
КонецФункции // ПоискИерархический()

// Процедура записывает данные по уровню. 
// 
// Параметры:
//  ВхСтрока - ДанныеФормыЭлементДерева.
// 
&НаСервере
Процедура ЗаписатьДанныеПоУровню(ВхСтрока)
	
	ТекДата   = ОбщегоНазначения.ТекущаяДатаПользователя();
	Коллекция = ВхСтрока.ПолучитьЭлементы();
	
	ПредыдущийЗаместитель  = "";
	ПредыдущийПользователь = "";

	Для каждого ТекущаяСтрока Из Коллекция Цикл
		
		// Проверка корректности интервала
		Если ЗначениеЗаполнено(ТекущаяСтрока.ДатаНачала) 
			 И ЗначениеЗаполнено(ТекущаяСтрока.ДатаОкончания) 
			 И ТекущаяСтрока.ДатаНачала > ТекущаяСтрока.ДатаОкончания Тогда
			 
			 ТекстСообщения =  НСтр("ru = 'Для заместителя ""%1%"" по области замещения ""%2%"" неверно указан интервал дат!'");
			 ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяСтрока.Заместитель, ТекущаяСтрока.ПредставлениеГруппировки);
			 бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			 
			 Продолжить;
		
		КонецЕсли; 
		
		Если ТекущаяСтрока.ЭтоДетальнаяЗапись И ТекущаяСтрока.Изменено Тогда
			
			флУдаление = Ложь;
			Если ЗначениеЗаполнено(ТекущаяСтрока.ЗаместительПредыдущий) И ТекущаяСтрока.ЗаместительПредыдущий <> ТекущаяСтрока.Заместитель Тогда
			
				 // Удаление предыдущего заместителя
				 Если ВРег(ТекущаяСтрока.ОбластьДанных) =  ВРег("Задачи") Тогда
					 МенеджерЗаписи = РегистрыСведений.бит_ЗаместителиПоЗадачам.СоздатьМенеджерЗаписи();
				 Иначе
					 МенеджерЗаписи = РегистрыСведений.бит_НазначенныеЗаместители.СоздатьМенеджерЗаписи();
				 КонецЕсли;
				 ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущаяСтрока);
				 МенеджерЗаписи.Заместитель = ТекущаяСтрока.ЗаместительПредыдущий;
				 МенеджерЗаписи.Прочитать();
				 
				 // Изменение кода. Начало. 27.12.2016{{
				 ЗаместительПредыдущий = ТекущаяСтрока.ЗаместительПредыдущий;
				 // Изменение кода. Конец. 27.12.2016}}
				 
				 Если МенеджерЗаписи.Выбран() Тогда
					 
					 Попытка
						 
						 МенеджерЗаписи.Удалить();
						 ТекущаяСтрока.Изменено = Ложь;
						 ТекущаяСтрока.ЗаместительПредыдущий = ТекущаяСтрока.Заместитель;
						 ТекущаяСтрока.ЗамАктивен = Ложь;
						 флУдаление = Истина;
						 
					 Исключение
						 
						 ТекстСообщения =  НСтр("ru = 'Не удалось удалить назначение заместителя ""%1%"" пользователю ""%2%"". Описание ошибки: ""%3%"".'");
						 ТекстСообщения =  бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения
						 , ТекущаяСтрока.Заместитель
						 , ТекущаяСтрока.Пользователь
						 , ОписаниеОшибки());
						 
						 бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);																			   
						 
					 КонецПопытки;
					 
				 КонецЕсли; 
			
			КонецЕсли; 
			
			флЗапись = Ложь;
			Если ЗначениеЗаполнено(ТекущаяСтрока.Заместитель) Тогда
				
				 // Установка заместителя
				 Если ВРег(ТекущаяСтрока.ОбластьДанных) =  ВРег("Задачи") Тогда
					 МенеджерЗаписи = РегистрыСведений.бит_ЗаместителиПоЗадачам.СоздатьМенеджерЗаписи();
				 Иначе
					 МенеджерЗаписи = РегистрыСведений.бит_НазначенныеЗаместители.СоздатьМенеджерЗаписи();
				 КонецЕсли;
				 
				 ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущаяСтрока);
				 МенеджерЗаписи.Прочитать();
				 ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущаяСтрока);
				 МенеджерЗаписи.Состояние   = РегистрыСведений.бит_НазначенныеЗаместители.ОпределитьСостояниеЗамещения(ТекущаяСтрока.ДатаНачала, ТекущаяСтрока.ДатаОкончания, ТекДата);
				 
				 Попытка
					 
					 МенеджерЗаписи.Записать();
		             ТекущаяСтрока.Изменено = Ложь;
					 ТекущаяСтрока.ЗаместительПредыдущий = ТекущаяСтрока.Заместитель;
					 Если МенеджерЗаписи.Состояние = Перечисления.бит_СостоянияЗаместителей.Назначен Тогда
					 
					 	ТекущаяСтрока.ЗамАктивен = Истина;
						
					КонецЕсли; 
					флЗапись = Истина;
					 
				 Исключение
					 
					 ТекстСообщения =  НСтр("ru = 'Не удалось назначить заместителя ""%1%"" пользователю ""%2%"". Описание ошибки: ""%3%"".'");
					 ТекстСообщения =  бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения
					                                                                               , ТекущаяСтрока.Заместитель
																								   , ТекущаяСтрока.Пользователь
																								   , ОписаниеОшибки());
																								   
					 бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);																			   
					 
				 КонецПопытки;
				 
				 Если ТекущаяСтрока.ПередаватьПраваРЛС Тогда
					 Если ПредыдущийПользователь <> ТекущаяСтрока.Пользователь ИЛИ ПредыдущийЗаместитель <> ТекущаяСтрока.Заместитель Тогда
						 
						 ПредыдущийЗаместитель  = ТекущаяСтрока.Заместитель;
						 ПредыдущийПользователь = ТекущаяСтрока.Пользователь;
					 
						 бит_ПраваДоступа.ПроверкаПрофилейДоступаПользователяИЗаместителя(ТекущаяСтрока.Заместитель, ТекущаяСтрока.Пользователь);
					 
					 КонецЕсли;
				КонецЕсли;
				 
			КонецЕсли; 
			
			Если флУдаление И НЕ флЗапись Тогда
			
				ТекущаяСтрока.ДатаНачала    = Неопределено;
				ТекущаяСтрока.ДатаОкончания = Неопределено;
			
			КонецЕсли; 
			
		Иначе
			
		  ТекущаяСтрока.Изменено = Ложь;
		  
		КонецЕсли; 
		
		ЗаписатьДанныеПоУровню(ТекущаяСтрока);
		
	КонецЦикла; 
	
КонецПроцедуры // ЗаписатьДанныеПоСтроке()

// Процедура управляет видимостью/доступностью элементов формы. 
// 
&НаСервере
Процедура УстановитьВидимость()

	Элементы.ФормаКомандаПанельНастроек.Пометка = Не фСкрытьПанельНастроек;
	Элементы.ГруппаНастройки.Видимость          = Не фСкрытьПанельНастроек;	

КонецПроцедуры // УстановитьВидимость()

&НаКлиенте
Процедура ДеревоДанныеПередаватьПраваРЛСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДеревоДанные.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
	УстановитьЗначениеИерархически(ТекущаяСтрока, "ПередаватьПраваРЛС", ТекущаяСтрока.ПередаватьПраваРЛС);

КонецПроцедуры

#КонецОбласти

// Процедура устанавливает значения в подчиненных строках дерева.
// 
// Параметры:
//  ТекСтрока - ДанныеФормыЭлементДерева.
//  ИмяКолонки - Строка
//  ЗначениеКолонки - Произвольный.
// 
&НаКлиенте
Процедура УстановитьЗначениеИерархически(ВхСтрока, ИмяКолонки, ЗначениеКолонки)
	
	ТекКоллекция = ВхСтрока.ПолучитьЭлементы();
	
	Для каждого ТекСтрока Из ТекКоллекция Цикл
	
		ТекСтрока[ИмяКолонки] = ЗначениеКолонки;
		ТекСтрока.Изменено = Истина;
		УстановитьЗначениеИерархически(ТекСтрока, ИмяКолонки, ЗначениеКолонки);
	
	КонецЦикла; 
	
КонецПроцедуры // УстановитьЗначениеИерархически()

// Функция формирует заголовок формы обработки.
// 
// Параметры:
//  РежимЗаполнения - Строка.
//  ТекущаяНастройка - СправочникСсылка.бит_СохраненныеНастройки.
// 
// Возвращаемое значение:
//  СтрЗаголовок - Строка.
// 
&НаКлиентеНаСервереБезКонтекста
Функция СформироватьЗаголовокФормы(ТекущаяНастройка)

	СтрЗаголовок =  НСтр("ru = 'Назначение заместителей'");
	
	Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
		
		СтрЗаголовок = СтрЗаголовок + "("+ТекущаяНастройка+")";
	
	КонецЕсли; 
	
	Возврат СтрЗаголовок;
	
КонецФункции // СформироватьЗаголовокФормы()

// Процедура устанавливает заголовок формы на клиенте.
// 
&НаКлиенте
Процедура УстановитьЗаголовокФормы()
	
	ЭтаФорма.Заголовок = СформироватьЗаголовокФормы(ТекущаяНастройка);
	
КонецПроцедуры // УстановитьЗаголовокФормы()

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
		
	// ДеревоДанные
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоДанные");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ДеревоДанные.Изменено", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.бит_ОсновнойЭлементСписка);
	
	// ДеревоДанные
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоДанные");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ДеревоДанные.ЗамАктивен", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.бит_ФонПодписьВерна);
	
	// ДеревоДанныеПередаватьПраваРЛС
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоДанныеПередаватьПраваРЛС");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ДеревоДанные.ОбластьДанных", ВидСравненияКомпоновкиДанных.Равно, "Задачи");
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры
 
#КонецОбласти
