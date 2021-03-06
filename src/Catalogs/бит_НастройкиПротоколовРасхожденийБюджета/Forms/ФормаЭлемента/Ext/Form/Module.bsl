
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	ЗаполнитьКэшЗначений();
	
	Элементы.Измерения.ОтборСтрок = Новый ФиксированнаяСтруктура("Отключено", Ложь);
	
	Если Параметры.Ключ.Пустая() Тогда
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ТекОбъект = Параметры.ЗначениеКопирования.ПолучитьОбъект();
			ЗаполнитьДобавленныеКолонкиТаблиц();
		Иначе	
			ЗаполнитьИзмеренияПоУмолчанию();
			Если ПустаяСтрока(Объект.ТекстЗапроса) И Объект.Периодичность > 0 Тогда
				ОбновитьТекстЗапроса();
			КонецЕсли; 
			ТекОбъект = РеквизитФормыВЗначение("Объект");
		КонецЕсли; 
	Иначе
		ТекОбъект = РеквизитФормыВЗначение("Объект");
		ЗаполнитьДобавленныеКолонкиТаблиц();
	КонецЕсли; 

	СохраненнаяНастройка = ТекОбъект.ПолучитьНастройкиПостроителя();
	
	// Инициализация компоновщика, используемого для настройки отборов.
	фАдресКомпоновки = Справочники.бит_НастройкиПротоколовРасхожденийБюджета.ИнициализироватьКомпоновщик(
						Объект.ТекстЗапроса, Компоновщик, УникальныйИдентификатор, Объект.Бюджет);
	
	Если СохраненнаяНастройка.Свойство("НастройкиКомпоновщика") 
		И ТипЗнч(СохраненнаяНастройка.НастройкиКомпоновщика) = Тип("НастройкиКомпоновкиДанных")  Тогда
		Если СохраненнаяНастройка.НастройкиКомпоновщика.Отбор.Элементы.Количество() > 0 Тогда
			Компоновщик.ЗагрузитьНастройки(СохраненнаяНастройка.НастройкиКомпоновщика);
		КонецЕсли;  
	КонецЕсли; 
		
	ЗаполнитьПоказатели();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Запомним отбор
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("НастройкиКомпоновщика", Компоновщик.ПолучитьНастройки());
	ТекущийОбъект.СохранитьНастройкиПостроителя(СтруктураНастройки);
	
	ЗаполнитьРесурсы(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьДобавленныеКолонкиТаблиц();
	ОбновитьТекстЗапроса();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Показатели = ПоказателиНастройки();
	ПоказателиВыбранны = Ложь;
	Для каждого Показатель Из Показатели Цикл
		ПоказателиВыбранны = Макс(ПоказателиВыбранны, ЭтотОбъект["Показатель" + Показатель]);
	КонецЦикла; 
	
	Если НЕ ПоказателиВыбранны Тогда
		ТекстСообщения = Нстр("ru = 'Не выбран показатель(и).'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "ПоказательСуммаРегл", ,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИзмеренияПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмеренияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура БюджетПриИзменении(Элемент)
	
	ОбновитьТекстЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	
	ОбновитьТекстЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмеренияВыполнятьПриИзменении(Элемент)
	
	ОбновитьТекстЗапроса();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.Измерения, "Выполнять", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаИнвертироватьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.Измерения, "Выполнять", 2);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.Измерения, "Выполнять", 0);
	
 КонецПроцедуры

 &НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ЗаполнитьИзмеренияПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьТекстЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументПротоколРасхожденийБюджета(Команда)
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("СоздатьДокументПРБВопросЗавершение", ЭтотОбъект);
		ТекстВопроса =  НСтр("ru = 'Элемент будет записан. Продолжить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 15, КодВозвратаДиалога.Нет);
		
	Иначе
		
		бит_РаботаСДиалогамиКлиент.ОткрытьНовуюФормуДокументаПротоколРасхожденийБюджета(Объект.Ссылка);
	
	КонецЕсли;
	
КонецПроцедуры // СоздатьДокументПротоколРасхожденийБюджета()

// Процедура обработчик оповещения "СоздатьДокументПРБВопросЗавершение".
//
// Параметры:
// Ответ 			    - КодВозвратаДиалога.
// ДополнительныеДанные - Структура.
//
&НаКлиенте 
Процедура СоздатьДокументПРБВопросЗавершение(Ответ, ДополнительныеДанные) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		флОК = Записать();
		
		Если флОК Тогда
			
			бит_РаботаСДиалогамиКлиент.ОткрытьНовуюФормуДокументаПротоколРасхожденийБюджета(Объект.Ссылка);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры	// СоздатьДокументПРБВопросЗавершение

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	
	фКэшЗначений.Вставить("НастройкиАналитик", бит_Бюджетирование.НастройкиИзмеренийБюджетирования());
	
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

&НаКлиентеНаСервереБезКонтекста
Функция ПоказателиНастройки()

	Показатели = Новый Массив(); 
	Показатели.Добавить("Количество");
	Показатели.Добавить("СуммаРегл");
	Показатели.Добавить("СуммаУпр");
	Показатели.Добавить("СуммаСценарий");

	Возврат Показатели;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоказатели()

	Показатели = ПоказателиНастройки();
	Для каждого СтрокаТаблицы Из Объект.Ресурсы Цикл
		Если Показатели.Найти(СтрокаТаблицы.Ресурс) <> Неопределено Тогда
			ЭтотОбъект["Показатель" + СтрокаТаблицы.Ресурс] = СтрокаТаблицы.Выполнять;
		КонецЕсли;
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРесурсы(ТекущийОбъект)

	ТекущийОбъект.Ресурсы.Очистить();
	Показатели = ПоказателиНастройки();
	Для каждого Показатель Из Показатели Цикл
		НоваяСтрока = ТекущийОбъект.Ресурсы.Добавить();
		НоваяСтрока.Ресурс 	  = Показатель;
		НоваяСтрока.Выполнять = ЭтотОбъект["Показатель" + Показатель];
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзмеренияПоУмолчанию()
	
	Объект.Измерения.Очистить();
	
	ИзмеренияБюджетирования = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("Произвольные", "Тип", "Структура");
	
	Для каждого КиЗ Из ИзмеренияБюджетирования Цикл
		НоваяСтрока = Объект.Измерения.Добавить();
	    НоваяСтрока.Имя = КиЗ.Ключ;
	КонецЦикла; 
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	// Установка видимости дополнительных измерений.
	ИзмеренияПроизвольные = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("произвольные","имя","массив");
	
	Для каждого Имя Из ИзмеренияПроизвольные Цикл
		Настройка = фКэшЗначений.НастройкиАналитик[Имя];
		СтрОтбор  = Новый Структура("Имя", Имя);
		Строки	  = Объект.Измерения.НайтиСтроки(СтрОтбор);
		Если Строки.Количество() > 0 Тогда
			ПерваяСтрока = Строки[0];
			Если Настройка = Неопределено Тогда
				ПерваяСтрока.Отключено = Истина;
			Иначе
				ПерваяСтрока.Представление = Настройка.Синоним;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстЗапроса()

	 ТекОбъект = РеквизитФормыВЗначение("Объект");
	 Объект.ТекстЗапроса = ТекОбъект.СформироватьТекстЗапроса();
	 
	 фАдресКомпоновки = Справочники.бит_НастройкиПротоколовРасхожденийБюджета.ИнициализироватьКомпоновщик(
	 						Объект.ТекстЗапроса, Компоновщик, УникальныйИдентификатор, Объект.Бюджет);

КонецПроцедуры

#КонецОбласти 
