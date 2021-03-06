#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйпрограммныйИнтерфейс

Процедура СкорректироватьКлючОбъектаПриОбновлении() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_НастройкиФормВводаБюджета.Ссылка,
	|	бит_НастройкиФормВводаБюджета.ТекстЗапроса
	|ИЗ
	|	Справочник.бит_НастройкиФормВводаБюджета КАК бит_НастройкиФормВводаБюджета
	|ГДЕ
	|	НЕ бит_НастройкиФормВводаБюджета.ЭтоГруппа";
				   
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Найти(Выборка.ТекстЗапроса, "бит_ЦФО") > 0 ИЛИ Найти(Выборка.ТекстЗапроса, "бит_Проекты") > 0 Тогда
			СпрОб = Выборка.Ссылка.ПолучитьОбъект();
			СпрОб.СформироватьТекстЗапроса();
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпрОб);
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьИспользоватьОбщиеИтогиПриОбновлении() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_НастройкиФормВводаБюджета.Ссылка
	|ИЗ
	|	Справочник.бит_НастройкиФормВводаБюджета КАК бит_НастройкиФормВводаБюджета
	|ГДЕ
	|	НЕ бит_НастройкиФормВводаБюджета.ЭтоГруппа
	|	И НЕ бит_НастройкиФормВводаБюджета.ВыводитьОбщиеИтоги";
	
	Результат = Запрос.Выполнить();			   
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СпрОб = Выборка.Ссылка.ПолучитьОбъект();
		СпрОб.ВыводитьОбщиеИтоги = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпрОб);		
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьВидНастройкиПриОбновлении() Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидПустой", Перечисления.бит_ВидыНастроекФормВводаБюджета.ПустаяСсылка());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрТаб.Ссылка
	|ИЗ
	|	Справочник.бит_НастройкиФормВводаБюджета КАК СпрТаб
	|ГДЕ
	|	НЕ СпрТаб.ЭтоГруппа
	|	И (СпрТаб.Вид = &ВидПустой
	|			ИЛИ СпрТаб.Цвет_Группа = """")";
				   
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекущийОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ТекущийОбъект.Вид = Перечисления.бит_ВидыНастроекФормВводаБюджета.Динамическая;
		ТекущийОбъект.ЦветаПоУмолчанию();
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТекущийОбъект);
	КонецЦикла; 
	
КонецПроцедуры

// Процедура заполняет реквизит Цвет_Аргумент в настройках форм ввода бюджета. 
// 
Процедура ЗаполнитьЦветАргументовПриОбновлении() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_НастройкиФормВводаБюджета.Ссылка
	|ИЗ
	|	Справочник.бит_НастройкиФормВводаБюджета КАК бит_НастройкиФормВводаБюджета
	|ГДЕ
	|	бит_НастройкиФормВводаБюджета.Цвет_Аргумент = """"";
	
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекущийОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ТекущийОбъект.Цвет_Аргумент = "#F1F1F1";
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТекущийОбъект);
	КонецЦикла;	
	
КонецПроцедуры
	
// Функция возвращает цвета формы ввода по-умолчанию.
// 
// Возвращаемое значение:
//  Цвета - Структура.
// 
Функция ЦветаПоУмолчанию() Экспорт

	Цвета = Новый Структура;
	
	Цвета.Вставить("Цвет_Группа","#FFFACD");  // LemonChiffon.
	Цвета.Вставить("Цвет_Ячейка","#90EE90");  // LightGreen.
	Цвета.Вставить("Цвет_Формула","#CCFFCC"); // Добавленный реквизит фон.
	Цвета.Вставить("Цвет_Аргумент","#F1F1F1");

	Возврат Цвета;
	
КонецФункции
   
// Подготавливает настройки измерений формы ввода бюджета 
// по элементу справочника бит_НастройкиФормВводаБюджета.
// 
// Параметры:
//  Настройка - СправочникСсылка.бит_НастройкиФормВводаБюджета.
// 
// Возвращаемое значение:
//  РезСтр - Структура.
// 
Функция ПодготовитьНастройки(Настройка) Экспорт

	РезСтр = Новый Структура;
	
	СпособыЗаполнения = Новый Соответствие;
	Для каждого ПеречислениеСсылка Из Перечисления.бит_СпособыЗаполненияИзмеренийВФормахВвода Цикл
	
		СпособыЗаполнения.Вставить(ПеречислениеСсылка, Новый Массив);
	
	КонецЦикла; 
	
	ИзмеренияПроизвольные = бит_Бюджетирование.НастройкиИзмеренийБюджетирования();	
	Измерения = Новый Структура;
	
	Для каждого СтрокаТаблицы Из Настройка.Измерения Цикл
	
		 Для каждого ПеречислениеСсылка Из Перечисления.бит_СпособыЗаполненияИзмеренийВФормахВвода Цикл
		 
		 	 Если СтрокаТаблицы.СпособЗаполнения = ПеречислениеСсылка Тогда
			 
			 	    СпособыЗаполнения[ПеречислениеСсылка].Добавить(СтрокаТаблицы.Имя);
			 
			 КонецЕсли; 
		 
		 КонецЦикла; 
		 
		 ТекИзмерениеПроизвольное = ИзмеренияПроизвольные[СтрокаТаблицы.Имя];
		 Синоним = ?(ТекИзмерениеПроизвольное = Неопределено, "", ТекИзмерениеПроизвольное.Синоним);
		 
		 ТекОписание = ОписаниеИзмерения(СтрокаТаблицы.Имя, Синоним, СтрокаТаблицы.СпособЗаполнения, СтрокаТаблицы.ЗначениеПоУмолчанию);
		 Измерения.Вставить(СтрокаТаблицы.Имя, ТекОписание);
		 
	КонецЦикла; 
	
	ДопИтоги = Новый Массив;
	Для каждого СтрокаТаблицы Из Настройка.ДополнительныеИтоги Цикл
	
		СтрОписание = Новый Структура("Периодичность, НарастающийИтог", СтрокаТаблицы.Периодичность, СтрокаТаблицы.НарастающийИтог);
		ДопИтоги.Добавить(СтрОписание);
	
	КонецЦикла; 
	
	РезСтр.Вставить("ФиксированныйМакет"     , ?(Настройка.Вид = Перечисления.бит_ВидыНастроекФормВводаБюджета.ФиксированныйМакет, Истина, Ложь));
	РезСтр.Вставить("ИмяКласса"              , "НастройкиИзмеренийФормыВводаБюджета");
	РезСтр.Вставить("Настройка"              , Настройка);
	РезСтр.Вставить("СпособыЗаполнения"      , СпособыЗаполнения);
	РезСтр.Вставить("Измерения"              , Измерения);
	РезСтр.Вставить("ДополнительныеИтоги"    , ДопИтоги);
	РезСтр.Вставить("ВыводитьОбщиеИтоги"     , Настройка.ВыводитьОбщиеИтоги);
	РезСтр.Вставить("УчетКоличество"         , Настройка.Учет_Количество);
	РезСтр.Вставить("УчетСумма"              , Настройка.Учет_Сумма);
	РезСтр.Вставить("Бюджет"                 , Настройка.Бюджет);
	РезСтр.Вставить("ОбъединятьЯчейки"       , Настройка.ОбъединятьЯчейки);
	РезСтр.Вставить("КоличествоРазворачивать", СпособыЗаполнения[Перечисления.бит_СпособыЗаполненияИзмеренийВФормахВвода.Разворачивать].Количество());
	РезСтр.Вставить("Периодичность"          , Настройка.ПериодичностьПланирования);
	РезСтр.Вставить("ОтображениеВыходных", ?(ЗначениеЗаполнено(Настройка.РежимОтображенияВыходныхДней)
	                                          , Настройка.РежимОтображенияВыходныхДней
											  , Перечисления.бит_РежимыОтображенияВыходныхДнейФормыВвода.Обычный));

	ЦветаУмолч = ЦветаПоУмолчанию();
	СтрЦвета = Новый Структура;
	СтрЦвета.Вставить("Цвет_Группа" , Обработки.бит_ПреобразованияЦветов.HexToColor(?(ЗначениеЗаполнено(Настройка.Цвет_Группа)
	                                                                                   , Настройка.Цвет_Группа
																					   , ЦветаУмолч.Цвет_Группа)));
																					   
	СтрЦвета.Вставить("Цвет_Ячейка" , Обработки.бит_ПреобразованияЦветов.HexToColor(?(ЗначениеЗаполнено(Настройка.Цвет_Ячейка)
	                                                                                   , Настройка.Цвет_Ячейка
																					   , ЦветаУмолч.Цвет_Ячейка)));
																					   
	СтрЦвета.Вставить("Цвет_Формула", Обработки.бит_ПреобразованияЦветов.HexToColor(?(ЗначениеЗаполнено(Настройка.Цвет_Формула)
	                                                                                    , Настройка.Цвет_Формула
																						, ЦветаУмолч.Цвет_Формула)));
																						
																						
	СтрЦвета.Вставить("Цвет_Аргумент", Обработки.бит_ПреобразованияЦветов.HexToColor(?(ЗначениеЗаполнено(Настройка.Цвет_Аргумент)
	                                                                                    , Настройка.Цвет_Аргумент
																						, ЦветаУмолч.Цвет_Аргумент)));
																						
	РезСтр.Вставить("Цвета", СтрЦвета);
	
	Если РезСтр.КоличествоРазворачивать > 0 Тогда
		
		РезСтр.Вставить("ИмяРазворачивать", СпособыЗаполнения[Перечисления.бит_СпособыЗаполненияИзмеренийВФормахВвода.Разворачивать][0])
		
	Иначе	
		
		РезСтр.Вставить("ИмяРазворачивать", "СтатьяОборотов");
		
	КонецЕсли; 
	
	Возврат РезСтр;
	
КонецФункции

// Процедура инициализирует компоновщик, используемый для фильтрации структуры дерева.
// 
Функция ИнициализироватьКомпоновщик(вхТекстЗапроса, Компоновщик, УникальныйИдентификатор, 
			ЗагрузитьНастройкиПоУмолчанию = Истина, Бюджет = Неопределено) Экспорт
	
	АдресКомпоновки = "";
	ТекстЗапроса = бит_МеханизмПолученияДанных.АдаптироватьТекстПостроителяДляКомпоновки(вхТекстЗапроса);
	
	ПредОтбор = Компоновщик.Настройки.Отбор.Элементы;
	
	Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда
		
		// Создаем СКД по запросу.
		СКД = СоздатьСхемуКомпоновкиПоЗапросу(ТекстЗапроса);
		
		Если Найти(ТекстЗапроса, "&Бюджет") > 0 Тогда
			// Параметр Бюджет не должен быть доступен в настройках СКД.
			ПараметрСКД = СКД.Параметры.Добавить();
			ПараметрСКД.Имя                      = "Бюджет";
			ПараметрСКД.Заголовок                = "Бюджет";
			ПараметрСКД.ТипЗначения              = Новый ОписаниеТипов("СправочникСсылка.бит_Бюджеты");
			ПараметрСКД.ВключатьВДоступныеПоля   = Ложь;
			ПараметрСКД.ОграничениеИспользования = Истина;
			ПараметрСКД.Значение                 = Бюджет;
		КонецЕсли; 
		
		НастройкиИзмерений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");
		бит_МеханизмДопИзмерений.СформироватьЗаголовкиПолейДополнительныхИзмеренийНастройкиФормыВвода(СКД, 
			"НаборДанныхОсновной",НастройкиИзмерений,,Ложь);	
		
		АдресКомпоновки = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
		
		// Инициализируем компоновщик.
		ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресКомпоновки);
		Попытка
			Компоновщик.Инициализировать(ИсточникНастроек);
		Исключение
			ТекстСообщения =  НСтр("ru = 'Не удалось инициализировать компоновщик для отбора. Попробуйте обновить текст запроса. Описание ошибки: %1%.'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ОписаниеОшибки());
			ВызватьИсключение ТекстСообщения;
		КонецПопытки;
		
		Если ЗагрузитьНастройкиПоУмолчанию Тогда
			Компоновщик.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
			Если ПредОтбор.Количество() > 0 Тогда
				Для каждого Эл Из ПредОтбор Цикл
					НовЭл = Компоновщик.Настройки.Отбор.Элементы.Добавить(Тип(Эл));
					ЗаполнитьЗначенияСвойств(НовЭл, Эл);
				КонецЦикла; 
				Компоновщик.Восстановить();
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат АдресКомпоновки;
	
КонецФункции

// Процедура проверяет множественный разворот по статьям оборотов.
// 
// Параметры:
//  ТабЧастьИзмерения - ТабличнаяЧасть.
//  Отказ - Булево.
// 
Процедура ПроверитьМножественныйРазворотПоСтатьям(ТабЧастьИзмерения, Отказ, ВыводитьСообщения = Истина)  Экспорт
	
	// Проверка на двойной разворот по статьи.
	ИзмеренияБюдж     = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("все","имя");		
	КолРазворотСтатья = 0;
	Для каждого СтрокаТаблицы Из ТабЧастьИзмерения Цикл
		
		СтрИзмер = ИзмеренияБюдж[СтрокаТаблицы.Имя];
		
		Если СтрИзмер.Имя = "бит_СтатьиОборотов" 
			 И СтрокаТаблицы.СпособЗаполнения = Перечисления.бит_СпособыЗаполненияИзмеренийВФормахВвода.Разворачивать Тогда
			
			КолРазворотСтатья = КолРазворотСтатья + 1;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	Если КолРазворотСтатья > 1 Тогда
		
		Если ВыводитьСообщения Тогда
			
			ТекстСообщения =  НСтр("ru = 'Не допускается более одного разворота по Статьям оборотов.'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецЕсли; 
		
		Отказ = Истина;
		
	КонецЕсли; 		
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Функция создает схему компоновки данных по тексту запроса.
// 
// Параметры:
// ТекстЗапроса - Строка
// ИмяНабораДанных - Строка
// 
// Возвращаемое значение:
//  СКД - СхемаКомпоновкиДанных.
// 
Функция СоздатьСхемуКомпоновкиПоЗапросу(ТекстЗапроса)
	
	СКД = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя 				  = "ИсточникДанных";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя 						 = "НаборДанныхОсновной"; 
	НаборДанных.ИсточникДанных 				 = "ИсточникДанных";
	НаборДанных.Запрос 						 = ТекстЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
		
	Построитель = Новый ПостроительЗапроса;
	Построитель.Текст = ТекстЗапроса;
	Построитель.ЗаполнитьНастройки();
	
	Для каждого ПолеПостроителя Из Построитель.ДоступныеПоля Цикл
		
		ПолеКомпоновки = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеКомпоновки.Поле = ПолеПостроителя.Имя;
		ПолеКомпоновки.ПутьКДанным = ПолеПостроителя.ПутьКДанным;
		ПолеКомпоновки.ОграничениеИспользованияРеквизитов.Порядок = Истина;
		ПолеКомпоновки.Заголовок = ?(ПолеПостроителя.Представление = "Ссылка", "Измерение", ПолеПостроителя.Представление);
		ПолеКомпоновки.Роль.Обязательное = Истина;
		
		Если ПолеПостроителя.Отбор Тогда
			ВыбранноеПоле = СКД.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(ПолеПостроителя.Имя);
		КонецЕсли; 
	КонецЦикла; 
	
	ГруппировкаКомпоновки = СКД.НастройкиПоУмолчанию.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ВыбранноеПоле         = ГруппировкаКомпоновки.Выбор.Элементы.Добавить(Тип("АвтовыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	
	Возврат СКД
	
КонецФункции

// Функция-конструктор структуры, описывающий измерение в форме ввода.
// 
// Параметры:
// Имя - Строка
// Синоним - Строка
// СпособЗаполнения - ПеречислениеСсылка.бит_СпособыЗаполненияИзмеренийВФормахВвода
// ЗначениеПоУмолчанию - Произвольный.
// 
// Возвращаемое значение:
//  РезСтруктура - Структура.
// 
Функция ОписаниеИзмерения(Имя, Синоним, СпособЗаполнения, ЗначениеПоУмолчанию)

	Результат = Новый Структура; 
	Результат.Вставить("ИмяКласса", 		 "НастройкаИзмеренияФормыВводаБюджета");
	Результат.Вставить("Имя",				 Имя);
	Результат.Вставить("Синоним", 			 Синоним);
	Результат.Вставить("СпособЗаполнения",	 СпособЗаполнения);
	Результат.Вставить("ЗначениеПоУмолчанию",ЗначениеПоУмолчанию);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли	
