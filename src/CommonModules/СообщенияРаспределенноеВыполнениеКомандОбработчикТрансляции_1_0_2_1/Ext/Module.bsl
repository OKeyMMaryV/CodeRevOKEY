////////////////////////////////////////////////////////////////////////////////
// СообщенияРаспределенноеВыполнениеКомандОбработчикТрансляции_1_0_2_1: 
// обработка трансляции сообщений подсистемы РаспределенноеВыполнениеКоманд.
////////////////////////////////////////////////////////////////////////////////

// Экспортные процедуры и функции для вызова из других подсистем
// 
#Область ПрограммныйИнтерфейс

// Возвращает номер версии, для трансляции с которой предназначен обработчик
Функция ИсходнаяВерсия() Экспорт
	
	Возврат СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_2_1.Версия();
	
КонецФункции

// Возвращает пространство имен версии, для трансляции с которой предназначен обработчик
Функция ПакетИсходнойВерсии() Экспорт
	
	Возврат СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_2_1.Пакет();
	
КонецФункции

// Возвращает номер версии, для трансляции в которую предназначен обработчик
Функция РезультирующаяВерсия() Экспорт
	
	Возврат СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_1_1.Версия();
	
КонецФункции

// Возвращает пространство имен версии, для трансляции в которую предназначен обработчик
Функция ПакетРезультирующейВерсии() Экспорт
	
	Возврат СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_1_1.Пакет();
	
КонецФункции

// Обработчик проверки выполнения стандартной обработки трансляции
//
// Параметры:
//  ИсходноеСообщение - ОбъектXDTO - транслируемое сообщение,
//  СтандартнаяОбработка - Булево - для отмены выполнения стандартной обработки трансляции
//    этому параметру внутри данной процедуры необходимо установить значение Ложь.
//    При этом вместо выполнения стандартной обработки трансляции будет вызвана функция
//    ТрансляцияСообщения() обработчика трансляции.
//
//@skip-warning Пустой метод
Процедура ПередТрансляцией(Знач ИсходноеСообщение, СтандартнаяОбработка) Экспорт
		
КонецПроцедуры

// Обработчик выполнения произвольной трансляции сообщения. Вызывается только в том случае,
//  если при выполнении процедуры ПередТрансляцией значению параметра СтандартнаяОбработка
//  было установлено значение Ложь.
//
// Параметры:
//  ИсходноеСообщение - ОбъектXDTO - транслируемое сообщение.
//
// Возвращаемое значение:
//  ОбъектXDTO - результат произвольной трансляции сообщения.
//
//@skip-warning Пустой метод
Функция ТрансляцияСообщения(Знач ИсходноеСообщение) Экспорт
		
КонецФункции

#КонецОбласти  